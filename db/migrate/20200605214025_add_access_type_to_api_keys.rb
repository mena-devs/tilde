class AddAccessTypeToApiKeys < ActiveRecord::Migration[5.2]
  def change
    add_column :api_keys, :access_type, :integer
  end
end
