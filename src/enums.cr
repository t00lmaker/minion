module Enums

  enum ContextKey
    ExecutionKey # :execution_key
    Workspace # :root
    Workdir # :workdir
    Result # :result
    Config # :config
    Group # :group
    Id # :id

    def symb
      keys(self)
    end

    def keys(key : ContextKey)
      {
        ExecutionKey => :execution_key,
        Workspace => :rootdir,
        Workdir => :wordir,
        Result => :result,
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
        Config => "MINION_CONFIG_FILE"
      }[key]
    end
  end

  enum ResultKey
    ExecutionError # :execution_error
    InvalidParams # :invalid_params
    InternalError # :internal_error
    Success # :success

    def str
      keys(self)
    end

    def keys(key : ResultKey) : String
      {
        ExecutionError => "execution_key",
        InvalidParams => "invalid_params",
        InternalError => "interno_error",
        Success => "success"
      }[key]
    end
  end
end