class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def slack
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user && @user.persisted?
      session['slack.custom_identifier'] = @user.custom_identifier
      sign_in_and_redirect @user, event: :authentication
    else
      # TODO: log errors generated from authenticating from omniauth
      session["devise.slack_data"] = request.env['omniauth.auth']
      logger.error("An error has occured while signing up via Slack credentials")
      logger.error(request.env['omniauth.auth'])

      redirect_to new_user_registration_url, alert: 'An error has occured while signing in using your Slack identity. If you are not a member of MENAdevs Slack group, you need to signup using your email address before logging in.'
    end
  end

  def failure
    redirect_to root_path
  end

  protected
    def after_omniauth_failure_path_for(_scope)
      new_user_session_path
    end

    def after_sign_in_path_for(resource_or_scope)
      stored_location_for(resource_or_scope) || root_path
    end
end
