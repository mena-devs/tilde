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
