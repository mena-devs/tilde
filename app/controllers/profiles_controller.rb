class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update]

  # GET /profiles/1
  def show
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
    # merging approved skills with the user skills (or else unapproved user skills
    # won't appear in the skills box [even if they were actually added by the user])

    @skills_autocomplete_list = []

    #loop and push approved skills
    Tag.where(is_approved: true).find_each do |skill|
      @skills_autocomplete_list.push(skill.name)
    end

    #loop and push user skills as well (while removing duplicates)
    @profile.skill_list.each do |skill_name|
      if !@skills_autocomplete_list.include? skill_name
            @skills_autocomplete_list.push(skill_name)
      end # if skill doesn't exist
    end # loop user skills
  end # edit

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
    # add the skills 'tags' to the profile data
    profile_data.merge!(skill_list: params[:skill_list].join(","))

    # update profile + user info
    if @profile.update(profile_data) && @profile.user.update(user_params)
      redirect_to user_profile_path(current_user), notice: 'Your profile was successfully updated.'
    else
      render :edit
    end
  end

  def disconnect_slack
    if @profile.user.disconnect_slack
      redirect_to @profile, notice: 'Disconnected your Slack account'
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
                                      :nickname, :skill_list,
                                      user: [:time_zone, :first_name, :last_name])
    end
end
