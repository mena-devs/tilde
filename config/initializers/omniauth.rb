Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack,
           '3378000868.155724249398',
           '202699c56ad4ee34621e2d04dfac9984',
           scope: 'users:read'
end
