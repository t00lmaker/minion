require "./context"
require "file_utils"
require "uuid"

class RequestRunner 
  include JSON::Serializable
  
  property id : String

  @[JSON::Field(key: "work")]
  property workName : String
  
  property params : Hash(String, String)

  @[JSON::Field(ignore: true)]
  property context = Context.new

  def run() : Context
    work = Config.work_by_name(workName)
    if work
      validate(work)
      create_workerdir(work)
      run_command(work)
    else
      raise "Woker #{workName} not found."
    end

    return context
  end

  def validate(work : Work) : Nil
    work.params.each do |p|
      unless(@params.has_key?(p.name))
        if p.required
          context[ContextKey::Result] = ResultKey::InvalidParams.str
        end
      end   
    end
  end

  def create_workerdir(work : Work) : Nil
    workdir = Config.instance.workspace
    execution_key = UUID.random.to_s
    workspace = Path.new(workdir, id, execution_key).to_s
    
    FileUtils.mkdir_p(workspace)

    context[ContextKey::Id] = id
    context[ContextKey::ExecutionKey] = execution_key
    context[ContextKey::Workspace] = workspace
    context[ContextKey::Workdir] = workdir
  end
  
  def run_command(work : Work) : Nil
    log_file = "#{context[ContextKey::Workspace]}/#{@workName}.log"
    status = Process.run(
      command: work.command,
      env: @params,  
      output: File.new(log_file, "w")
    )
     success = status.normal_exit?
     result = success ? ResultKey::Success : ResultKey::ExecutionError
     context[ContextKey::Result] = result.str
  end
end
