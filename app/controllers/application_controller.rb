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
    if user_signed_in? && current_user.profile && !current_user.profile.complete?
      redirect_to edit_user_profile_path(current_user), alert: 'Please complete your profile before proceeding any further'
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
