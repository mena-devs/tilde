class AddAasmStateToInvitations < ActiveRecord::Migration[5.0]
  def change
    add_column :invitations, :aasm_state, :string
    add_column :invitations, :retries, :integer, default: 0

    ActiveRecord::Base.record_timestamps = false
    Invitation.update_all(aasm_state: 'sent')
    ActiveRecord::Base.record_timestamps = true
  end
end
