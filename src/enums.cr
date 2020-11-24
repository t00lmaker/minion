module Enums
  enum ContextKey
    ExecutionKey # :execution_key
    Workspace # :root
    Workdir # :workdir
    Result # :result
    Status # :status
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
        Status => :status,
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

  enum StatusKey
    Running # :execution_error
    InvalidParams # :invalid_params
    InternalError # :internal_error
    Finished # :success

    def str
      keys(self)
    end

    def keys(key : ResultKey) : String
      {
        Running => "execution_key",
        InvalidParams => "invalid_params",
        InternalError => "interno_error",
        Finished => "success"
      }[key]
    end
  end
end