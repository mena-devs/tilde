class CrossCheckInvitationsWithSlackAndUpdate < ActiveRecord::Migration[5.2]
  def change
    ActiveRecord::Base.record_timestamps = false
    Invitation.update_invitations_statuses
    ActiveRecord::Base.record_timestamps = true
  end
end
