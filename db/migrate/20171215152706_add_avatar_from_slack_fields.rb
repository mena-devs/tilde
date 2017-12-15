class AddAvatarFromSlackFields < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :avatar_from_slack_imported, :boolean, default: false
    add_column :profiles, :avatar_from_slack_updated_at, :datetime
  end
end
