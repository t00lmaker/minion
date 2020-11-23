

class TaskRunner

  property stdout = IO::Memory.new

  def initialize(request : RequestRunner)
    @request = request
  end

  def run()
    cmd = @request.work.try &.command
    status = Process.run(
      command: cmd,
      env: @request.params,
      output: @stdout
    )
    stdout.close
    self
  end

  def save_log
    context = @request.context 
    work = @request.work 
    path = "#{context[ContextKey::Workspace]}/#{work.name}.log"
    File.new(path, "w")
    File.write(path, @stdout.to_s)
    self
  end

  def outputs
    logs = @stdout.to_s
    self
  end

  def notify
    self 
  end
end