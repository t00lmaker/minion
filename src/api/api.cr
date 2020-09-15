require "kemal"
require "./request_runner"
require "../config"

include Config

config = Config.instance

get "/info/:work" do |env|
  env.response.content_type = "application/json"
  work = env.params.url["work"]
  Config.work_by_name(work).to_json
end

get "/info" do |env|
  env.response.content_type = "application/json"
  config.to_json
end

post "/run/:work" do |env|
  env.response.content_type = "application/json"
  
  work = env.params.url["work"]
  
  work = Config.work_by_name(work).first
  begin
    request = RequestRunner.from_json(env.request.body.not_nil!)
    result = request.run(work)
  rescue ex
    halt env, status_code: 400, response: ex.message
  end

  {:result => result}.to_json
end

Kemal.run
