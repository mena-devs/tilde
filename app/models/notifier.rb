require 'slack-notifier'

class Notifier
  def self.get_notifier
    notifier = Slack::Notifier.new(AppSettings.slack_web_hook_url,
                                    channel: AppSettings.slack_job_channel,
                                    username: 'Tilde ~')
    return notifier
  end

  def self.post_job_to_slack(job_id)
    @notifier = Notifier.get_notifier
    job = Job.find(job_id).decorate

    message = {
        "attachments": [
            {
                "fallback": ":briefcase: #{job.title}",
                "text": ":briefcase: #{job.title}",
                "fields": [
                    {
                        "title": "Company",
                        "value": job.company_name,
                        "short": true
                    },
                    {
                        "title": "Posted by",
                        "value": job.user.name,
                        "short": true
                    },
                    {
                        "title": "Country",
                        "value": job.location_name,
                        "short": true
                    },
                    {
                        "title": "Job is remote or has remote working as an option?",
                        "value": job.remote.to_s,
                        "short": true
                    },
                    {
                        "title": "Expected salary",
                        "value": job.salary_to_s,
                        "short": true
                    },
                    {
                        "title": "Job has equity or Stock Options?",
                        "value": job.equity.to_s,
                        "short": true
                    },
                    {
                        "title": "Apply by email to",
                        "value": job.apply_email,
                        "short": true
                    },
                    {
                        "title": "For more information, check the following job post:",
                        "value": "#{AppSettings.application_host}/jobs/#{job.to_param}?md=slack",
                        "short": false
                    }
                ],
                "color": "#F35A00"
            }
        ]
    }
    @notifier.ping(message, channel: AppSettings.slack_job_channel)
  end
end
