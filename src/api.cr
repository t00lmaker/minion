require "kemal"
require "./order"
require "./config"
require "./enums"

include Config
include Enums

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

post "/run" do |env|
  env.response.content_type = "application/json"

  begin
    request = Order.from_json(env.request.body.not_nil!)
    result = request.run()
  rescue ex
    puts ex.inspect_with_backtrace
    halt env, status_code: 400, response: ex.message
  end

  result.to_json
end

ENV["KEMAL_ENV"] = ENV["KEMAL_ENV"]? || "development"

unless ENV["KEMAL_ENV"] == "test"
  Kemal.run
end