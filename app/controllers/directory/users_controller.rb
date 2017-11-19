class Directory::UsersController < ApplicationController
  before_action :set_user, only: [:show]
  # devise authentication required to access invitations
  before_action :authenticate_user!, only: :show

  def index
    if user_signed_in?
      @users = User.members_profile
    else
      @users = User.open_profile
    end

    if user_params[:name] && safe_param
      search_letter = "^[" + user_params[:name].downcase + "].*"
      @users = @users.where("lower(first_name) ~ ?", search_letter).order(:first_name, :last_name).page(params[:page])
    else
      @users = @users.order(:first_name, :last_name).page(params[:page])
    end
  end

  def show
    if (@user.profile.privacy_level == 0 ||
          @user.profile.privacy_level == 1 && !user_signed_in?)

        flash[:alert] = "Your profile is hidden"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(user_params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:id, :name)
    end

    def safe_param
      ('a'..'z').to_a.include?(user_params[:name].downcase)
    end
end
