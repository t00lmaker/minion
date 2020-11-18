require "../config"

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

  end
  
  def run_command(work : Work)
    Process.run(
      command: work.command,
      env: @params,  
      output: File.new("/home/luan/#{@workName}.log", "w")
    )
  end
end