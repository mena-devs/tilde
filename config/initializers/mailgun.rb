unless Rails.env.development?
  Mailgun.configure do |config|
    config.api_key = AppSettings.mailgun_api_key
  end
end
