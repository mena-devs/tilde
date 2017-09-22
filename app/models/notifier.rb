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
    job = Job.find(job_id)

    message = {
        "attachments": [
            {
                "fallback": ":briefcase: #{job.title.titleize}",
                "text": ":briefcase: #{job.title.titleize}",
                "fields": [
                    {
                        "title": "Company",
                        "value": job.company_name.titleize,
                        "short": true
                    },
                    {
                        "title": "Posted by",
                        "value": job.user.name,
                        "short": true
                    },
                    {
                        "title": "Expected salary",
                        "value": job.from_salary,
                        "short": true
                    },
                    {
                        "title": "Details",
                        "value": "#{AppSettings.application_host}/job/#{job.custom_identifier}?md=slack",
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
