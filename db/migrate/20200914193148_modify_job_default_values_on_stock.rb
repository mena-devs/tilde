class ModifyJobDefaultValuesOnStock < ActiveRecord::Migration[5.2]
  def change
    ActiveRecord::Base.record_timestamps = false
    change_column_default :jobs, :equity, false
    ActiveRecord::Base.record_timestamps = true
  end
end