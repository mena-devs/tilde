class CreateJobStatistics < ActiveRecord::Migration[5.0]
  def change
    create_table :job_statistics do |t|
      t.references :job, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :counter, default: 1

      t.timestamps
    end
  end
end
