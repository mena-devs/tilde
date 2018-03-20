class UserMailer < ApplicationMailer
  def complete_profile(user_identifier)
    @user = User.friendly.find(user_identifier)

    subject = "MENAdevs - please complete your profile"

    mail to: @user.email,
         subject: subject
  end
end
