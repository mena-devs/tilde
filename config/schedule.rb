every 1.day do
  runner "User.email_new_users_with_incomplete_profiles"
end

every 7.days do
  runner "User.delete_unverified_accounts"
end

every :day, at: '10:00pm' do
  runner "Job.remove_expired_jobs"
end

every :day, at: '11:55pm' do
  runner "Job.notify_daily_digest_subscribers"
end