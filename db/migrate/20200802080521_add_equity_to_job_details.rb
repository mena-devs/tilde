class AddEquityToJobDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :equity, :boolean
  end
end