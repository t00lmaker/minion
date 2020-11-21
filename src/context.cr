require "json"

class Context
  property keys

  def initialize(@keys = {} of Symbol => String);end

  def []=(key : Symbol, value : String)
    @keys[key] = value
  end

  def [](key : Symbol)
    @keys[key]
  end

  def []=(key : ContextKey, value : String)
    @keys[key.symb] = value
  end

  def [](key : ContextKey)
    @keys[key.symb]
  end

  def to_json(builder : JSON::Builder)
    builder.object do
      @keys.each { |k, v| builder.field k, v } 
    end 
  end
end
