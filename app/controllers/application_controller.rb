class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # API access
  before_filter :restrict_access, if: :api_request
  before_filter :authenticate_with_token!, if: :api_request

  def api_request
    if (request.original_url =~ /api\// || request.content_type =~ /application\/json/)
      return true
    end
    false
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

      device = Device.find_by_authentication_token(auth_token)

      if (user_token.blank? || device.blank?)
        @user = nil
      else
        @user = device.user
      end

      if (@user && Devise.secure_compare(device.authentication_token, user_token))
        sign_in @user
      else
        render status: :unauthorized,
               nothing: true
      end
    end

    def restrict_access
      authenticate_or_request_with_http_token do |token, options|
        if api_key = ApiKey.find_by_access_token(token)
          @user_id = api_key.user_id
        end
        api_key
      end
    end
end
