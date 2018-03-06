class MembersController < ApplicationController
  # devise authentication required to access invitations
  before_action :authenticate_user!
  before_action :is_admin
  before_action :set_user, only: [:show]

  # GET /members
  def index
    @users_count = User.unscoped.count
    @users = User.verified.unscoped.order('created_at desc').page(params[:page])

    respond_to do |format|
      format.html
    end
  end

  # GET /member/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(user_params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:id)
    end

    def is_admin
      unless user_signed_in? && current_user.admin?
        redirect_to root_path, error: "You are not authorised to access this resource" and return
      end
    end
end
