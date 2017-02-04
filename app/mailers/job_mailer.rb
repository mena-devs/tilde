class JobMailer < ApplicationMailer
  def new_job(job)
    @job = job

    subject = "Someone posted a new job on MENADevs.com"

    mail to: "email@cnicolaou.com",
         subject: subject
  end

  def job_published(job)
    @job = job

    subject = "Your job is now posted live on menadevs.com"

    mail to: "email@cnicolaou.com",
         subject: subject
  end

  def job_unpublished(job)
    @job = job

    subject = "Your job post is no longer live on menadevs.com"

    mail to: "email@cnicolaou.com",
         subject: subject
  end
end
