class Directory::UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    if user_signed_in?
      @members = User.members_profile
    else
      @members = User.open_profile
    end

    if (user_params.has_key?(:name) && safe_param)
      # Filtering by NAME is enabled
      search_letter = "^[" + user_params[:name].downcase + "].*"
      @users = @members.where("lower(first_name) ~ ?", search_letter).order(:first_name, :last_name).page(params[:page])
    else
      # Filtering by interest is enabled
      if (params.has_key?(:state))
        filter_by_params
        @members.sort_by! {|user| [user.first_name, user.last_name]}
      end

      @users = Kaminari.paginate_array(@members).page(params[:page]).per(10)
    end

    return @users
  end

  def show
    if (@user.profile.privacy_level == 0 ||
          @user.profile.privacy_level == 1 && !user_signed_in?)

        flash[:alert] = "Profile is hidden"
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

    def filter_by_params
      state_params = params[:state]

      if state_params == 'new_role'
        @members = @members.select { |member| member.profile.a_new_role == "1" }
      elsif state_params == 'freelance'
        @members = @members.select { |member| member.profile.freelance == "1" }
      elsif state_params == 'mentor'
        @members = @members.select { |member| member.profile.to_mentor_someone == "1" }
      elsif state_params == 'mentee'
        @members = @members.select { |member| member.profile.being_mentored == "1" }
      end
    end
end
