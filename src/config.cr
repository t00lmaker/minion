require "yaml"
require "json"

module Config

  @@config : Minion?

  def self.instance
    path_config = ENV[ContextKey::Config.env]
    path_config ||= "~/minion.yml"
    @@config ||= load(path_config)
  end

  def self.load(path : String) : Minion
    yaml = File.open(path)
    Minion.from_yaml(yaml)
  end

  def self.work_by_name(name : String)
    self.instance.works.select{ |w| w.name == name }.first
  end

  class Minion
    include JSON::Serializable
    include YAML::Serializable

    property name : String

    property desc : String?

    property workspace : String

    property group : String?

    property works : Array(Work)

  end

  class Work
    include JSON::Serializable
    include YAML::Serializable

    property name : String

    property command : String

    property params : Array(Param)

  end

  class Param
    include JSON::Serializable
    include YAML::Serializable

    property name : String

    property desc : String? 

    @[YAML::Field(key: "type")]
    @[JSON::Field(key: "type")]
    property typeParam : ParamType

    property required = true
  end

  enum ParamType
    Text
    Number
    List

    def parser(value : String)
      proc = parser(self)
      proc.call(value)
    end

    def parser(key : ParamType)
      {
        Text => ->(value : String){ value.as(String) },
        Number => ->(value : String){ value.as(Float) },
        List   => ->(value : String){ value.split(",") }
      }[key]
    end
  end

end
