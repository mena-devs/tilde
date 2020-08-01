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

  def display_button_filter_class(parameters, state=nil)
    class_data = 'button button-directory button-3d button-mini button-rounded'
    
    if (state.nil? && !parameters.has_key?(:state))
      class_data += ' button-teal'
    elsif (!state.nil? && parameters[:state] == state)
      class_data += ' button-teal'
    end

    class_data
  end
end