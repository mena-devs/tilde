module JobsHelper
  def job_creator_name(job)
    if job.user
      job.user.try(:name)
    else
      "Not defined"
    end
  end

  def job_salary(job)
    return "" if job.from_salary.blank?

    return number_to_currency(job.from_salary, precision: 0) if job.to_salary.blank?

    number_to_currency(job.from_salary, precision: 0) + " - " + number_to_currency(job.from_salary, precision: 0)
  end
end
