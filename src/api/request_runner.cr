require "../config"
require "file_utils"
require "uuid"

class RequestRunner 
  include JSON::Serializable
  
  property id : String

  @[JSON::Field(key: "work")]
  property workName : String
  
  property params : Hash(String, String)

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
    workspace = Config.instance.workspace
    execution_key = UUID.random.to_s
    workdir = "#{workspace}#{id}#{execution_key}"
    workdir = Path.new(workspace, id, execution_key)
    FileUtils.mkdir_p(workdir.to_s)
  end
  
  def run_command(work : Work)
    Process.run(
      command: work.command,
      env: @params,  
      output: File.new("/home/luan/#{@workName}.log", "w")
    )
  end
end