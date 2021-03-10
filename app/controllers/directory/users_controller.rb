class Directory::UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    if user_signed_in?
      @members = User.members_profile
    else
      @members = User.open_profile
    end

    @members = @members.order(:first_name, :last_name)

    if (user_params.has_key?(:name) && safe_param)
      search_letter = "^[" + user_params[:name].downcase + "].*"
      @users = @members.where("lower(first_name) ~ ?", search_letter).order(:first_name, :last_name).page(params[:page])
    else
      filter_and_sort_content_by_params

      @users = Kaminari.paginate_array(@members).page(params[:page]).per(10)
    end

    @users
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

    def filter_and_sort_content_by_params
      return unless params.has_key?(:state)

      case params[:state].downcase.strip
      when 'new_role'
        @members = @members.select { |member| member.profile.a_new_role == "1" }
      when 'freelance'
        @members = @members.select { |member| member.profile.freelance == "1" }
      when 'mentor'
        @members = @members.select { |member| member.profile.to_mentor_someone == "1" }
      when 'mentee'
        @members = @members.select { |member| member.profile.being_mentored == "1" }
      else
        flash[:notice] = "Unsupported parameters"
        Event.new_event("Exception: #{exception.message}", current_user, request.remote_ip)
        redirect_to "/"
      end

      @members.sort_by! {|user| [user.first_name, user.last_name]}
    end
end
