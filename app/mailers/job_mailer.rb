class JobMailer < ApplicationMailer
  add_template_helper(JobsHelper)

  def new_job(job_id)
    @job = Job.find(job_id)

    subject = "MENAdevs - #{@job.user.try(:name)} posted a new job"

    mail to: AppSettings.admin_email,
         subject: subject
  end

  def job_published(job_id)
    @job = Job.find(job_id)

    subject = "MENAdevs - Your job is now posted on the job board"

    mail to: @job.user.email,
         subject: subject
  end

  def job_unpublished(job_id)
    @job = Job.find(job_id)

    subject = "MENAdevs - Your job post is now offline"

    mail to: @job.user.email,
         subject: subject
  end

  def notify_subscriber(job_id, subscriber_id)
    @job = Job.find(job_id).decorate
    @subscriber = User.find(subscriber_id)

    subject = "MENAdevs - A new job is available online"

    mail to: @subscriber.email,
         subject: subject
  end
end
