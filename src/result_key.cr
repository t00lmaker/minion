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
