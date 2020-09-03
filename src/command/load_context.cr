require "yaml"

class LoadContext < Command

  def initialize(@context : Context)
    ENV[ContextKey::Rootdir.env] ||= "~/"
    ENV[ContextKey::Config.env]  ||= "#{ENV[ContextKey::Rootdir.env]}minion.yml"
  end

  def execute
    @context[ContextKey::Rootdir] = ENV[ContextKey::Rootdir.env]
    @context[ContextKey::Config] = ENV[ContextKey::Config.env]
  end
end