class AddCompanyTwitterHandleToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :twitter_handle, :string
  end
end
