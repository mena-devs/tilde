class Private::DashboardsController < ApplicationController
  # devise authentication required to access invitations
  before_action :authenticate_user!
  before_action :is_admin

  # GET /private/dashboard
  def show
    users = User.today
    @members = User.count
    @verified_members = User.verified.count
    @today_new_members = users.count
    @today_verified_members = users.verified.count
    @administrators = User.admins
  end

  private
    def is_admin
      unless user_signed_in? && current_user.admin?
        redirect_to root_path, error: "You are not authorised to access this resource" and return
      end
    end
end