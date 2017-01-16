class Directory::UsersController < ApplicationController
  before_action :set_user, only: [:show]
  # devise authentication required to access invitations
  before_action :authenticate_user!, only: :show
  # GET /invitations
  def index
    @users = User.all.order(:first_name, :last_name)
  end

  # GET /invitations/1
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
end
