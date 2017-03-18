Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack,
           AppSettings.slack_app_client_id,
           AppSettings.slack_app_client_secret,
           scope: 'users:read users:read.email'
end
