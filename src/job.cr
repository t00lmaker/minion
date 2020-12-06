require "uuid"
require "file_utils"
require "http/client"

class Job

  property stdout = IO::Memory.new

  property outputs  = {} of String => String

  def initialize(@order : Order, @context : Context); end

  def validate_params : Job
    Log.info{ "Validate params" } 
    @order.works.each do |w|
      w.params.each do |p|
        unless(@order.params.has_key?(p.name))
          if p.required
            @context[ContextKey::Result] = ResultKey::InvalidParams.str
          end
        end
      end
    end

    self
  end

  def create_workerdir : Job

    Log.info{ "Create workspace" }

    workdir = Config.instance.workdir
    scripts = "#{Config.instance.scripts}/"
    execution_key = UUID.random.to_s
    workspace = Path.new(workdir, @order.id, execution_key).to_s

    FileUtils.mkdir_p(workspace)
    FileUtils.cp_r(scripts, workspace)

    Log.info{ workspace }

    @context[ContextKey::Id] = @order.id
    @context[ContextKey::ExecutionKey] = execution_key
    @context[ContextKey::Workspace] = workspace
    @context[ContextKey::Workdir] = workdir
   
    
    self
  end

  def execute : Job
    @order.works.each do |work|
      cmd = work.command
      status = Process.run(
        command: cmd,
        env: @order.params,
        output: @stdout,
        chdir: @context[ContextKey::Workspace]
      )
      Log.info{ "Execution log: \n#{@stdout.to_s}" } 
      result = status.normal_exit? ? ResultKey::Success : ResultKey::ExecutionError
      @context[ContextKey::Result] = result.str
    end

    self
  end

  def save : Job
    Log.info{ "Save Log" } 
    path = "#{@context[ContextKey::Workspace]}/out.log"
    File.new(path, "w")
    File.write(path, @stdout.to_s)

    self
  end

  OUTPUT = "!#OUTPUT"

  def outputs : Job
    log = @stdout.to_s
    log.each_line.each do |line|
      if line.includes? OUTPUT
        line = line.delete(OUTPUT)
        split = line.split "="
        if split.size == 2
          key=split[0].strip
          value=split[1].strip
          @outputs[key]=value
        else
          raise "incorrect format output"
        end
      end
    end

    self
  end

  def notify : Job
    Log.info{ "Send outpus to callback" }
    response = HTTP::Client.post(@order.callback, body: @outputs.to_json)
    self
  end

end