class AddCompanyNameAndTwitterHandleToProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :company_name, :string
    add_column :profiles, :twitter_handle, :string
  end
end
