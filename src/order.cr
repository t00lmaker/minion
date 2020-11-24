require "file_utils"
require "uuid"

require "./context"
require "./job"

class WorkConverter

  def from_json(pull : JSON::PullParser)
    Config.work_by_name(pull.read_string)
  end

  def to_json(work : Work, builder : JSON::Builder)
    builder.string(value.name)
  end
end

class Order
  include JSON::Serializable

  property id : String

  property params : Hash(String, String)

  @[JSON::Field(ignore: true)]
  property context = Context.new

  @[JSON::Field(converter: WorkConverter.new)]
  property work : Work

  def run() : Context
    validate_params
    create_workerdir
    execute_order
    context
  end

  def validate_params() : Nil
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

  def execute_order() : Nil
    spawn do
        Job
          .new(self)
          .execute
          .save
          .respond
          .notify
    end
  end
end
