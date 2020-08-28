require "./spec_helper"
require "../src/context"

describe Context do 
  
  describe "#put a value" do 
    it "A value should be add in context ..." do 
      context = Context.new
      context[:key] = "value"
      context[:key].should eq("value")
    end    
  end
end
