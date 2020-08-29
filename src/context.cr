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
end
