class  Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def slack
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
    else
      # TODO: log errors generated from authenticating from omniauth
      session["devise.slack_data"] = request.env["omniauth.auth"]
      logger.info("An error has occured")
      logger.info(request.env["omniauth.auth"])

      redirect_to new_user_registration_url, alert: 'An error has occured while signing in using your Slack identity. Please try again in a few minutes.'
    end
  end

  def failure
    redirect_to root_path
  end
end
