require "yaml"

module Config

  def load(path : String)
    yaml = File.open(path)
    Minion.from_yaml(yaml)
  end

  class Minion
    include YAML::Serializable

    @[YAML::Field(key: "name")]
    property name : String

    @[YAML::Field(key: "desc")]
    property desc : String?

    @[YAML::Field(key: "works")]
    property works : Array(Work)

  end

  class Work
    include YAML::Serializable

    @[YAML::Field(key: "command")]
    property command : String

    @[YAML::Field(key: "params")]
    property params : Array(Param)

  end

  class Param
    include YAML::Serializable

    @[YAML::Field(key: "name")]
    property name : String

    @[YAML::Field(key: "desc")]
    property desc : String? 

    @[YAML::Field(key: "type")]
    property typeParam : ParamType

  end

  enum ParamType
    String
    Number
  end

end
