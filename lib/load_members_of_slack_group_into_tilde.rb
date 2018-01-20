SlackApi.all_users['members'].each do |user|
  if user['deleted'] == false && user['is_bot'] == false
    User.update_user_from_slack(user)
  end
end
