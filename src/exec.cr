
require "log"

Log.info { "Program started" }

cmd = "sh"

args = [] of String

args << "/home/luan/package.sh"

Log.info { "Process init .." }

io = File.new("/home/luan/package.log", "w")

p = Process.new(cmd, args, output: io)

Log.info { "Process wait" }

result = p.wait

Log.info { "Process result #{result.exit_code}"}

ENV["PORT"] ||= "5000"

Log.info { ENV["PORT"] }