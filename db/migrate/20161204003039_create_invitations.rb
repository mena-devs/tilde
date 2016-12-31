class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.references :user, foreign_key: true
      t.string :invitee_name
      t.string :invitee_email
      t.string :invitee_title
      t.string :invitee_company
      t.string :invitee_location
      t.text   :invitee_introduction
      t.boolean :delivered, default: false
      t.boolean :registered, default: false

      t.timestamps
    end
  end
end
