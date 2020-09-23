class MigrateExistingEquityFieldsOnJobs < ActiveRecord::Migration[5.2]
  def change
    ActiveRecord::Base.record_timestamps = false
    Job.all.each do |job|
      if job.equity.blank?
        job.update(equity: false)
      end
    end
    ActiveRecord::Base.record_timestamps = true
  end
end