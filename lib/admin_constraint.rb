# Needed and used to access sidekiq
class AdminConstraint
  def matches?(request)
    user = request.env['warden'].user(:user)
    user && user.admin?
  end
end