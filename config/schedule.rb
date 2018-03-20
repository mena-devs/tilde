every 1.day do
  runner "User.email_new_users_with_incomplete_profiles"
end

every 1.day do
  runner "User.delete_unverified_accounts"
end
