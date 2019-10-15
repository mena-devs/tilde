class NotificationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.announcement.subject
  #
  def announcement(user_identifier, subject)
    @user = User.friendly.find(user_identifier)

    mail to: @user.email,
         subject: subject
  end
end