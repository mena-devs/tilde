# Configure OmniAuth to only allow requests from :post and :get
OmniAuth.config.allowed_request_methods = [:post, :get]

if !AppSettings.slack_app_client_id.blank? && !AppSettings.slack_app_client_secret.blank?
  Rails.application.config.middleware.use(OmniAuth::Builder) do
    provider :slack,
             AppSettings.slack_app_client_id,
             AppSettings.slack_app_client_secret,
             scope: AppSettings.slack_app_scopes
  end
elsif Rails.env.production? || Rails.env.development?
  raise Exception.new("Please configure /config/settings/*.yml with correct values")
end
