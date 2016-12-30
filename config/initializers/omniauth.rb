Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack,
           '3378000868.113106258167',
           '9d006046e71b0203a6d1a3e4a426ccc1',
           scope: 'users:read'
end
