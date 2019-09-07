# == Schema Information
#
# Table name: job_statistics
#
#  id         :bigint           not null, primary key
#  job_id     :integer
#  user_id    :integer
#  counter    :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class JobStatistic < ApplicationRecord
    belongs_to :user
    belongs_to :job

    def self.increment(job_id, user_id)
        job_statistic = JobStatistic.find_by(job_id: job_id, user_id: user_id)

        if job_statistic.blank?
            job_statistic = JobStatistic.create(job_id: job_id, user_id: user_id)
        else
            job_statistic.update_attribute(:counter, (job_statistic.counter + 1))
        end
        
        return job_statistic
    end
end
