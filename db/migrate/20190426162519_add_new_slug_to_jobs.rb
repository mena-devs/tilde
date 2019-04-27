class AddNewSlugToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :slug, :string
    add_index :jobs, :slug, unique: true
    ActiveRecord::Base.record_timestamps = false
    Job.all.each(&:save)
    ActiveRecord::Base.record_timestamps = true
  end
end