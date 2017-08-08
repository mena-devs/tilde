class JobMailer < ApplicationMailer
  add_template_helper(JobsHelper)

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

  def notify_subscriber(job_id, subscriber_id)
    @job = Job.find(job_id)
    @subscriber = User.find(subscriber_id)

    subject = "A new job has been posted on MENAdevs.com"

    mail to: @subscriber.email,
         subject: subject
  end
end
