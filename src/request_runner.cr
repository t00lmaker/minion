require "./config"
require "./context"
require "./context_key"
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

  def run
    work = Config.work_by_name(workName).first
    return unless work
    validate(work)
    create_workerdir(work)
    run_command(work)
  end

  def validate(work : Work)
    work.params.each do |p|
      unless(@params.has_key?(p.name))
        raise "#{p.name} é obrigatório" if p.required
      end   
    end
  end

  def create_workerdir(work : Work)
    workdir = Config.instance.workspace
    execution_key = UUID.random.to_s
    workspace = Path.new(workdir, id, execution_key).to_s
    
    FileUtils.mkdir_p(workspace)

    context[ContextKey::ExecutionKey] = execution_key
    context[ContextKey::Workspace] = workspace
    context[ContextKey::Workdir] = workdir
  end
  
  def run_command(work : Work)
    log_file = "#{context[ContextKey::Workspace]}/#{@workName}.log"
    puts log_file
    Process.run(
      command: work.command,
      env: @params,  
      output: File.new(log_file, "w")
    )
  end
end