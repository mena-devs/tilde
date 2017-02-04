class JobMailer < ApplicationMailer
  def new_job(job)
    @job = job

    subject = "Someone posted a new job on MENADevs.com"

    mail to: "email@cnicolaou.com",
         subject: subject
  end
end
