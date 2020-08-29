enum ContextKey
  Rootdir #root
  Workdir # :workdir
  Config # :config
  Group # :group
  Id # :id

  def symb
    keys(self)
  end

  def keys(key : ContextKey)
    {
      Rootdir => :rootdir,
      Workdir => :wordir,
      Config => :config,
      Group => :group, 
      Id =>  :id
    }[key]
  end
  
  def env
    env(self)
  end

  def env(key : ContextKey)
    {
      Rootdir => "MINION_ROOT_DIR",
      Config => "MINION_CONFIG_FILE",
    }[key]
  end
end