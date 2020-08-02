module InvitationsHelper
  def display_invitation_state(invitation)
    (invitation.aasm_state != 'accepted') ? 'Pending' : invitation.aasm_state.titleize
  end

  def display_tilde_membership(invitation)
    invitation.registered? ? 'Yes' : 'No'
  end

  def display_tilde_member(invitation)
    if invitation.registered?
      user = User.find_by_email(invitation.invitee_email)
      link_to(invitation.invitee_email, directory_user_path(user.custom_identifier))
    else
      invitation.invitee_email
    end
  end
end