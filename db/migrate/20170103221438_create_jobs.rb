class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :description
      t.string :job_location
      t.string :custom_identifier
      t.datetime :posted_on
      t.datetime :expires_on
      t.integer :state, default: 0
      t.boolean :approved, default: false
      t.boolean :posted_to_slack, default: false
      t.references :user, foreign_key: true
      t.string :company_name
      t.string :apply_email
      t.integer :job_type, default: 0
      t.integer :level, default: 0
      t.boolean :paid

      t.timestamps
    end
  end
end
