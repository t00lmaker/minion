
require "kemal"



get "/info/:work" do |env|

  spawn do
    loop do
      sleep 3
      puts env.params.url["work"]
    end
  end

  puts "=("
  
  "Oh yes"
end


Kemal.run


log_file = "#{context[ContextKey::Workspace]}/#{@work.name}.log"
    
    stdout = IO::Memory.new
    
    status = Process.run(
      command: work.command,
      env: @params,
      output: @stdout
    )
    
    File.new(log_file, "w")
    success = status.normal_exit?
    result = success ? ResultKey::Success : ResultKey::ExecutionError
    @context[ContextKey::Result] = result.str