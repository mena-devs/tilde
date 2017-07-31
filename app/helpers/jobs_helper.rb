module JobsHelper
  def job_creator_name(job)
    if job.user
      job.user.try(:name)
    else
      "Not defined"
    end
  end

  def job_salary(job)
  	if job.to_salary.blank?
  		job_salary = "starting #{job.from_salary}"
  	else
  		job_salary = "between #{job.from_salary} and #{job.to_salary}"
  	end

  	job_salary
  end
end
