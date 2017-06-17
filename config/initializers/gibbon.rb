unless Rails.env.development?
  Gibbon::Request.api_key = AppSettings.mailchimp_api_key
  Gibbon::Request.timeout = 15
end
