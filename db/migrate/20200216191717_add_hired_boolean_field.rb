class AddHiredBooleanField < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :hired, :boolean, default: false
  end
end
