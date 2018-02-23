module InvitationsHelper
  def display_invitation_state(invitation)
    if invitation.aasm_state != 'accepted'
      'pending'
    end
  end
end
