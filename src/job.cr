require "./enums"

class Job

  property stdout = IO::Memory.new

  def initialize(request : Order)
    @request = request
  end

  def execute : Job
    cmd = @request.work.command
    status = Process.run(
      command: cmd,
      env: @request.params,
      output: @stdout
    )
    @stdout.close
    result = status.normal_exit? ? ResultKey::Success : ResultKey::ExecutionError
    @request.context[ContextKey::Result] = result.str
    self
  end

  def save : Job
    context = @request.context
    work = @request.work
    path = "#{context[ContextKey::Workspace]}/#{work.name}.log"
    File.new(path, "w")
    File.write(path, @stdout.to_s)
    self
  end

  def respond : Job
    @stdout.to_s
    self
  end

  def notify : Job
    self
  end
end