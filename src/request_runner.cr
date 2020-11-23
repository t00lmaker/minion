require "file_utils"
require "uuid"

require "./context"
require "./task_runner"

class WorkConverter 

  def from_json(pull : JSON::PullParser)
    Config.work_by_name(pull.read_string)
  end

  def to_json(work : Work, builder : JSON::Builder)
    builder.string(value.name)
  end
end

class RequestRunner
  include JSON::Serializable

  property id : String

  property params : Hash(String, String)

  @[JSON::Field(ignore: true)]
  property context = Context.new

  @[JSON::Field(converter: WorkConverter.new)]
  property work : Work

  def run() : Context
    validate
    create_workerdir
    run_command
    context
  end

  def validate() : Nil
    @work.try &.params.each do |p|
      unless(@params.has_key?(p.name))
        if p.required
          context[ContextKey::Result] = ResultKey::InvalidParams.str
        end
      end
    end
  end

  def create_workerdir() : Nil
    workdir = Config.instance.workspace
    execution_key = UUID.random.to_s
    workspace = Path.new(workdir, id, execution_key).to_s

    FileUtils.mkdir_p(workspace)

    context[ContextKey::Id] = id
    context[ContextKey::ExecutionKey] = execution_key
    context[ContextKey::Workspace] = workspace
    context[ContextKey::Workdir] = workdir
  end

  def run_command() : Nil
    spawn do
      TaskRunner
          .new(self)
          .run
          .outputs
          .save_log
          .notify
    end 
  end
end
