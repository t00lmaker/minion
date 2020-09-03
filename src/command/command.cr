abstract class Command
 
  def apply?
    true
  end

  abstract def execute
end
