# Be sure to restart your server when you modify this file.
require 'sidekiq/web'

Rails.application.config.session_store :active_record_store, :key => '_mena_devs_session'

# Turn off Sinatra's sessions, which overwrite the main Rails app's session
# after the first request
Sidekiq::Web.disable(:sessions)