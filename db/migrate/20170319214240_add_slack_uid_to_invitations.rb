class AddSlackUidToInvitations < ActiveRecord::Migration[5.0]
  def change
    add_column :invitations, :slack_uid, :string
    add_column :invitations, :medium, :string
  end
end
