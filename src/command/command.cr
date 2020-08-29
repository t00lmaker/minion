abstract class Command
  property context

  def apply?
    true
  end

  def run(context : Context)
    @context = context
    execute(context) if apply?
  end

  abstract def execute(context : Context)
end
