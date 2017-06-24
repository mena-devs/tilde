module JobsHelper
  def job_invitee_name(job)
    if job.user
      job.user.try(:name)
    else
      "Not defined"
    end
  end
end
