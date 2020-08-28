

class Context 

  def initialize
    @map = {} of Symbol => String
  end

  def []=(key : Symbol, value : String)
    @map[key] = value
  end

  def [](key : Symbol)
    @map[key]
  end

end
