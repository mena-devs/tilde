class JobMailer < ApplicationMailer
  def new_job(job_id)
    @job = Job.find(job_id)

    subject = "[MENAdevs] Someone posted a new job"

    mail to: @job.user.email,
         subject: subject
  end

  def job_published(job_id)
    @job = Job.find(job_id)

    subject = "[MENAdevs] Your job is now posted live"

    mail to: @job.user.email,
         subject: subject
  end

  def job_unpublished(job_id)
    @job = Job.find(job_id)

    subject = "[MENAdevs] Your job post is no longer live"

    mail to: @job.user.email,
         subject: subject
  end
end
