class Directory::UsersController < ApplicationController
  before_action :set_user, only: [:show]
  # devise authentication required to access invitations
  before_action :authenticate_user!, only: :show

  def index
    @users = User.order(:first_name, :last_name).page params[:page]
  end

  def show
    if (@user.profile.privacy_level == 0 ||
          @user.profile.privacy_level == 1 && !user_signed_in?)
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
        format.xml { head :not_found }
        format.any { head :not_found }
      end
    end
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
end
