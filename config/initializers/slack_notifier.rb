slack_web_hook_url = 'https://hooks.slack.com/services/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'
@notifier = Slack::Notifier.new(slack_web_hook_url,
                                channel: '#default',
                                username: 'notifier')
