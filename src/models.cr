

# A Job is work execution. 
class Job

end

# A result is um Job output.
class Result

  property id : String 

  property execution_key : String

  property outputs  = {} of Symbol => String

  def initialize(@id, @execution_key, @outputs); end

end

# A Order is external request exection of a Worker.
class Order
  include JSON::Serializable

  property id : String

  property params : Hash(String, String)

  property callback : String

  @[JSON::Field(converter: JSON::ArrayConverter(WorkConverter))]
  property works : Array(Work)

end

# convert name work in to Work from config (Load work from config.)
class WorkConverter
  def self.from_json(pull : JSON::PullParser)
    Config.work_by_name(pull.read_string)
  end

  def self.to_json(value : Work, builder : JSON::Builder)
    builder.string(value.name)
  end
end
