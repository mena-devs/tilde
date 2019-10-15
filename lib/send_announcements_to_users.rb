User.job_alert_subscribers.each do |user|
  NotificationsMailer.announcement(user.id, "MENA Devs Build Night #4 - get your tickets now!").deliver_later
end