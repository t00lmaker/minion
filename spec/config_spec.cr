require "./spec_helper"

describe Config do

  it "load config from yml config" do
    config = Config.load("spec/assets/minion.yml")
    config.name.should eq("minion1")
  end

  it "load config from yml config requeried param erro" do
    expect_raises(YAML::ParseException) do
      Config.load("spec/assets/minion-require-erro.yml")
    end
  end

  it "load config from yml config" do
    expect_raises(ArgumentError) do
      Config.load("spec/assets/minion-type-erro.yml")
    end
  end
end