class RenameProfileJobAlertsFieldAndAddNewField < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :receive_job_alerts_frequency, :integer, default: 0

    ActiveRecord::Base.record_timestamps = false
    Profile.all.each do |profile|
      if profile.receive_job_alerts
        profile.update_attribute(:receive_job_alerts_frequency, Profile.job_alerts_frequencies["Instant"])
      end
    end
    ActiveRecord::Base.record_timestamps = true

    remove_column :profiles, :receive_job_alerts
  end
end
