class JobMailer < ApplicationMailer
  add_template_helper(JobsHelper)

  def new_job(job_id)
    @job = Job.find(job_id).decorate

    subject = "MENAdevs - #{@job.user.try(:name)} posted a new job '#{@job.title}''"

    mail to: AppSettings.admin_email,
         reply_to: @job.user.email,
         subject: subject
  end

  def job_published(job_id)
    @job = Job.find(job_id).decorate

    subject = "MENAdevs - Job '#{@job.title}' is published on the job board"

    mail to: @job.user.email,
         subject: subject
  end

  def job_unpublished(job_id)
    @job = Job.find(job_id).decorate

    subject = "MENAdevs - Job '#{@job.title}' is now offline"

    mail to: @job.user.email,
         subject: subject
  end

  def notify_subscriber(job_id, subscriber_id)
    @job = Job.find(job_id).decorate
    @subscriber = User.find(subscriber_id)

    subject = "MENAdevs - New job alert: '#{@job.title}'"

    mail to: @subscriber.email,
         subject: subject
  end
end
