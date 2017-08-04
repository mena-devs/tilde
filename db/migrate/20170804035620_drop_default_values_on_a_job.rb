class DropDefaultValuesOnAJob < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:jobs, :employment_type, nil)
    change_column_default(:jobs, :experience, nil)
    change_column_default(:jobs, :employment_type, nil)
  end
end
