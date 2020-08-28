enum ContextKey
  Workdir # :workdir
  Group # :group
  Id # :id

  def symb
    map(self)
  end

  def map(key : ContextKey)
    {
      Workdir => :wordir,
      Group => :group, 
      Id =>  :id
    }[key]
  end
end