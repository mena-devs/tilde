class AddActiveToUserModel < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :active, :boolean, default: true
    ActiveRecord::Base.record_timestamps = false
    User.update_all(active: true)
    ActiveRecord::Base.record_timestamps = true
  end
end
