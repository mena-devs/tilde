class JobMailer < ApplicationMailer
  add_template_helper(JobsHelper)

  def new_job(job_id)
    @job = Job.find(job_id).decorate

    subject = "MENAdevs - #{@job.user.try(:name)} posted a new job"

    mail to: AppSettings.admin_email,
         reply_to: @job.user.email,
         subject: subject
  end

  def job_published(job_id)
    @job = Job.find(job_id).decorate

    subject = "MENAdevs - Your job post is published on the job board"

    mail to: @job.user.email,
         subject: subject
  end

  def job_unpublished(job_id)
    @job = Job.find(job_id).decorate

    subject = "MENAdevs - Your job post is now offline"

    mail to: @job.user.email,
         subject: subject
  end

  def notify_job_alert_instant_subscriber(job_id, subscriber_id)
    @job = Job.find(job_id).decorate
    @subscriber = User.find(subscriber_id)

    subject = "MENAdevs - A new job is posted on the job board"

    mail to: @subscriber.email,
         subject: subject
  end

  def notify_job_alert_daily_digest_subscriber(jobs, subscriber_id)
    @jobs = jobs
    @subscriber = User.find(subscriber_id)

    subject = "MENAdevs - New jobs for #{Date.today}"

    mail to: @subscriber.email,
         subject: subject
  end
end
