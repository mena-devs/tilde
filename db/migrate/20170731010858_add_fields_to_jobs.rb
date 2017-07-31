class AddFieldsToJobs < ActiveRecord::Migration[5.0]
  def change
  	add_column :jobs, :from_salary, :string
  	add_column :jobs, :currency, :string
  	add_column :jobs, :education, :string

    rename_column :jobs, :salary, :to_salary
    rename_column :jobs, :job_type, :employment_type
    rename_column :jobs, :level, :experience
    rename_column :jobs, :location, :country
	  rename_column :jobs, :remote_ok, :remote
	  rename_column :jobs, :job_description_location, :external_link
  end
end