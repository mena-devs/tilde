class SlackApi
  def self.get_user_info(auth)
    base_uri = 'https://slack.com/api/users.info'
    api_response = HTTParty.get(base_uri, query: {token: auth.credentials.token,
                                                  user: auth.uid})
    raise api_response.inspect
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
