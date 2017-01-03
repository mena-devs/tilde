class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

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
end
