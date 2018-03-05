redis_url = ENV.fetch("REDIS_URL")
Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{redis_url}:6379/12", :namespace => "mena_devs_com" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{redis_url}:6379/12", :namespace => "mena_devs_com" }
end

require "sidekiq/web"
Sidekiq::Web.app_url = "/"
Sidekiq::Web.use(Rack::Auth::Basic, "Application") do |username, password|
  username == ENV.fetch("SIDEKIQ_WEB_USERNAME") &&
  password == ENV.fetch("SIDEKIQ_WEB_PASSWORD")
end
