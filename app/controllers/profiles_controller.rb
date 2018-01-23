class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :reload_avatar]
  before_action :authenticate_user!

  # GET /profiles/1
  def show
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles
  def create
    @profile = Profile.new(profile_params)

    if @profile.save
      redirect_to @profile, notice: 'Your profile was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /profiles/1
  def update
    user_params = profile_params["user"]
    profile_data = profile_params.reject {|k,v| k == "user"}
    if @profile.update(profile_data) && @profile.user.update(user_params)
      redirect_to user_profile_path(current_user.custom_identifier), notice: 'Your profile was successfully updated.'
    else
      render :edit
    end
  end

  def disconnect_slack
    if @profile.user.disconnect_slack
      redirect_to edit_user_profile_path(current_user.custom_identifier), notice: 'Disconnected your Slack account'
    else
      render :edit
    end
  end


  def reload_avatar
    if @profile.reload_avatar_from_slack
      redirect_to edit_user_profile_path(current_user.custom_identifier), notice: 'Updated profile picture from your Slack account'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = User.friendly.find(params[:user_id]).profile
    end

    # Only allow a trusted parameter "white list" through.
    def profile_params
      params.require(:profile).permit(:biography, :location, :receive_emails,
                                      :receive_job_alerts, :privacy_level,
                                      :nickname, :avatar, :title,
                                      :a_new_role, :collaborate_on_a_project, :freelance,
                                      :to_mentor_someone, :being_mentored, :participate_at_events,
                                      user: [:time_zone, :first_name, :last_name])
    end
end
