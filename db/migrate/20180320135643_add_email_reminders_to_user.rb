class AddEmailRemindersToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email_reminders, :string
  end
end
