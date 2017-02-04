class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.string :aasm_state
      t.string :title
      t.text :description
      t.string :job_description_location
      t.string :location
      t.boolean :remote_ok, default: false
      t.string :custom_identifier
      t.datetime :posted_on
      t.datetime :expires_on
      t.boolean :posted_to_slack, default: false
      t.references :user, foreign_key: true
      t.string :company_name
      t.string :apply_email
      t.string :salary
      t.integer :job_type, default: 0
      t.integer :number_of_openings, default: 1
      t.integer :level, default: 0
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :jobs, :deleted_at
  end
end
