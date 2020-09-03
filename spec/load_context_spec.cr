require "./spec_helper"

describe LoadContext do

  before_each do 
    ENV.delete(ContextKey::Rootdir.env)
    ENV.delete(ContextKey::Config.env)
  end

  describe "load env vars" do
    it "should loaded values to env" do
      ENV[ContextKey::Rootdir.env] = "/home/user/"
      ENV[ContextKey::Config.env] = "/home/user/cfg"
      context = Context.new
      LoadContext.new(context).execute
      context[ContextKey::Rootdir].should eq "/home/user/"
      context[ContextKey::Config].should eq "/home/user/cfg"
    end
    it "should has default values" do
      context = Context.new
      LoadContext.new(context).execute
      context[ContextKey::Rootdir].should eq "~/"
      context[ContextKey::Config].should eq "~/minion.yml"
    end
    it "should meger values to env and defauls" do
      ENV[ContextKey::Rootdir.env] = "/home/user/"
      context = Context.new
      LoadContext.new(context).execute
      context[ContextKey::Rootdir].should eq "/home/user/"
      context[ContextKey::Config].should eq "/home/user/minion.yml"
    end
  end

  describe "load yml file" do 
    it "should be load file" do 
      ENV[ContextKey::Rootdir.env] = "spec/assets/"
      context = Context.new
      LoadContext.new(context).execute
    end
  end 
end
