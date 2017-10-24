class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # API access
  before_filter :authenticate_with_token!, if: :api_request

  def api_request
    if (request.original_url =~ /api\// || request.content_type =~ /application\/json/)
      return true
    end
    false
  end

  def check_user_profile_complete
    if user_signed_in && current_user.profile && !current_user.profile.complete?
      redirect_to edit_user_profile_path(current_user), alert: 'Please update your profile'
    end
  end

  # if user did not fill his profile yet
  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url

    if current_user.profile.try(:complete?) && request.referer == sign_in_url
      super
    elsif current_user.profile.nil?
      current_user.create_profile
      edit_user_profile_path(current_user)
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  private
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
