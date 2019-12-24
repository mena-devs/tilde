class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # API access
  before_action :authenticate_with_token!, if: :api_request

  def after_sign_in_path_for(resource)
    session[:custom_identifier] = resource.custom_identifier
    root_path
  end

  def api_request
    if (request.original_url =~ /api\// || request.content_type =~ /application\/json/)
      return true
    end
    false
  end

  def check_user_profile_complete
    if user_signed_in? && current_user.profile && !current_user.profile.complete?
      redirect_to edit_user_profile_path(current_user), alert: 'Please complete your profile before proceeding'
    end
  end

  def authenticate_admin
    unless user_signed_in? && current_user.admin?
      redirect_to root_path, alert: "Not authorised"
    end
  end

  def user_is_admin?
    (user_signed_in? && current_user.admin?)
  end

  def can_log_stats?(job)
    (job.approved? && (user_signed_in? && !current_user.admin?))
  end

  def can_see_stats?(job)
    (user_signed_in? && (job.user_id == current_user.id || current_user.admin?) )
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue
    render_404
  end

  def render_404
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  private
    # def current_user
    #   begin
    #     puts @current_user.inspect
    #     @current_user ||= User.find_by_custom_identifier(session[:custom_identifier]) if session[:custom_identifier]
    #   rescue ActiveRecord::RecordNotFound
    #     nil
    #   end
    # end

    def authenticate_with_token!
      auth_token = params[:auth_token].presence

      api_key = ApiKey.where(access_token: auth_token).first

      if (auth_token.blank? || api_key.blank?)
        @user = nil
      else
        @user = api_key.user
      end

      if (@user && Devise.secure_compare(api_key.access_token, auth_token))
        sign_in @user
      else
        render status: :unauthorized,
               nothing: true
      end
    end
end
