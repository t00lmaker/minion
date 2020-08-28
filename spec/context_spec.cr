require "./spec_helper"
require "../src/context"

describe Context do

  describe "init" do
    it "hash like sintax ..." do
      context = Context{:key => "value"}
      context[:key].should eq("value")
    end
    it "empty ..." do
      context = Context.new
      context.map.should_not be_nil 
      context.map.should be_empty
    end
  end

  describe "put and get" do
    it "key" do
      context = Context.new
      context[:key] = "value"
      context[:key].should_not be_nil
      context[:key].should eq("value")
    end

    it "key override" do
      context = Context.new 
      context[:key] = "value"
      context[:key].should_not be_nil
      context[:key].should eq("value")
      context[:key] = "value2"
      context[:key].should_not be_nil
      context[:key].should eq("value2")
    end

    it "use key context enum" do 
      context = Context.new
      context[ContextKey::Id] = "id"
      context[ContextKey::Id].should_not be_nil
      context[ContextKey::Id].should eq("id")
    end
  end
end
