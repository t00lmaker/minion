class Context
  property map

  def initialize(@map = {} of Symbol => String);end

  def []=(key : Symbol, value : String)
    @map[key] = value
  end

  def [](key : Symbol)
    @map[key]
  end

  def []=(key : ContextKey, value : String)
    @map[key.symb] = value
  end

  def [](key : ContextKey)
    @map[key.symb]
  end
end
