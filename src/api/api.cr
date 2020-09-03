require "kemal"
require "../config"


include Config

config = Config.instance

get "/" do
  "Hello World!"
end

get "/info" do |env|
  env.response.content_type = "application/json"
  config.to_json
end

Kemal.run
