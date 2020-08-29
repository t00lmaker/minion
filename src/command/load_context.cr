class LoadContext < Command

  def execute(context : Context)
    ENV[ContextKey::Rootdir.env] ||= "~/"
    ENV[ContextKey::Config.env]  ||= "#{ENV[ContextKey::Rootdir.env]}minion.yml"

    context[ContextKey::Rootdir] = ENV[ContextKey::Rootdir.env]
    context[ContextKey::Config] = ENV[ContextKey::Config.env]
  end
end