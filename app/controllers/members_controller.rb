class MembersController < ApplicationController
  # devise authentication required to access invitations
  before_action :authenticate_user!
  before_action :is_admin
  before_action :set_user, only: [:show]

  # GET /members
  def index
    users = User.verified.joins(:profile)
    @users_count = users.count
    @users = users.order('created_at desc').page(params[:page])

    respond_to do |format|
      format.html
    end
  end

  # GET /member/1
  def show
  end

  # GET /members/news-email-subscribers.csv
  def news_email_subscribers
    news_subscribers = verified_users.news_subscribers
    
    respond_to do |format|
      format.csv { send_data news_subscribers.to_csv, filename: "menadevs-tilde-news-email-subscribers-#{DateTime.now.strftime("%Y_%m_%d_%H%M%S")}.csv" }
    end
  end

  # GET /members/jobs-email-subscribers.csv
  def jobs_email_subscribers
    jobs_subscribers = verified_users.job_alert_subscribers
    
    respond_to do |format|
      format.csv { send_data jobs_subscribers.to_csv, filename: "menadevs-tilde-jobs-email-subscribers-#{DateTime.now.strftime("%Y_%m_%d_%H%M%S")}.csv" }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(user_params[:id])
    end

    def verified_users
      @subscribers = User.verified.order("users.first_name", "users.last_name")
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
