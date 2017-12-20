Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0', :namespace => "mena_devs_com" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0', :namespace => "mena_devs_com" }
end

require "sidekiq/web"
Sidekiq::Web.app_url = "/"
Sidekiq::Web.use(Rack::Auth::Basic, "Application") do |username, password|
  username == ENV.fetch("SIDEKIQ_WEB_USERNAME") &&
  password == ENV.fetch("SIDEKIQ_WEB_PASSWORD")
end
