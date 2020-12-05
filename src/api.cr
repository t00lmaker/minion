require "kemal"
require "log"
require "./models"
require "./config"
require "./enums"
require "./context"
require "./job"

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
    context = Context.new 
    order = Order.from_json(env.request.body.not_nil!)
    
    spawn do
      Job
        .new(order, context)
        .validate_params
        .create_workerdir
        .execute
        .save
        .outputs
        .notify
    end
    order.to_json

  rescue ex
    puts ex.inspect_with_backtrace
    halt env, status_code: 400, response: ex.message
  end

  #result.to_json
end

ENV["KEMAL_ENV"] = ENV["KEMAL_ENV"]? || "development"

unless ENV["KEMAL_ENV"] == "test"
  Kemal.run
end
