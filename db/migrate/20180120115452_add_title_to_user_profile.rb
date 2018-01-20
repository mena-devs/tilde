class AddTitleToUserProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :title, :string
  end
end
