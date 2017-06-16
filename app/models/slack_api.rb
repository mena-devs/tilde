class SlackApi
  def self.get_user_info(slack_uid)
    base_uri = 'https://slack.com/api/users.info'
    api_response = HTTParty.get(base_uri, query: {token: AppSettings.slack_legacy_token,
                                                  user: slack_uid})

    json_hash = api_response.parsed_response
    return json_hash
  end

  def self.send_invitation(email)
    base_uri = 'https://slack.com/api/users.admin.invite'
    api_response = HTTParty.get(base_uri, query: { token: AppSettings.slack_legacy_token,
                                                   email: email })

    json_hash = api_response.parsed_response
    return json_hash
  end
end
