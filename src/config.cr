require "yaml"
require "json"
require "./context_key"

module Config

  @@config : Minion | Nil

  def self.instance
    path_config = ENV[ContextKey::Config.env]
    path_config ||= "~/minion.yml"
    @@config ||= load(path_config)
  end

  def load(path : String) : Minion
    yaml = File.open(path)
    Minion.from_yaml(yaml)
  end

  class Minion
    include JSON::Serializable
    include YAML::Serializable

    property name : String

    property desc : String?

    property works : Array(Work)

  end

  class Work
    include JSON::Serializable
    include YAML::Serializable

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

  end

  enum ParamType
    String
    Number
  end

end
