if !AppSettings.slack_app_client_id.blank? && !AppSettings.slack_app_client_secret.blank?
  Rails.application.config.middleware.use(OmniAuth::Builder) do
    provider :slack,
             AppSettings.slack_app_client_id,
             AppSettings.slack_app_client_secret,
             scope: 'users:read users:read.email'
  end
else
  raise Exception.new("Please configure /config/settings/*.yml with correct values")
end
