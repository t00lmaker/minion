abstract class Command
  
  def initilize(context : Context)
    @context = context
  end
  
  def apply?
    true
  end

  def run
    execute() if apply?
  end

  abstract def execute()
end
