class SlackApi
  def self.get_user_info(slack_uid)
    base_uri = 'https://slack.com/api/users.info'
    api_response = HTTParty.get(base_uri, query: {token: AppSettings.slack_token,
                                                  user: slack_uid})

    json_hash = api_response.parsed_response

    puts json_hash.inspect

    return json_hash
  end

  def self.send_invitation(email)
    base_uri = 'https://slack.com/api/users.admin.invite'
    api_response = HTTParty.get(base_uri, query: { token: AppSettings.slack_token,
                                                   email: email })

    return api_response.parsed_response
  end

  def self.all_users
    base_uri = 'https://slack.com/api/users.list'
    api_response = HTTParty.get(base_uri, query: {token: AppSettings.slack_token})

    return api_response.parsed_response
  end
end
