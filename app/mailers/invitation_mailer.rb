class InvitationMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitation_mailer.welcome_email.subject
  #
  def welcome_email(invitation)
    @invitation = invitation

    mail to: @invitation.invitee_email
  end

  def new_slack_invitation(invitation)
    @invitation = invitation

    mail to: AppSettings.admin_email,
         subject: "[MENAdevs] We've received an invitation to join our Slack group"
  end
end
