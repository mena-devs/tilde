@notifier = Slack::Notifier.new(AppSettings.slack_web_hook_url,
                                channel: '#default',
                                username: 'Tilde')
