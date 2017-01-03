module ApplicationHelper
  def is_user_a_slack_member?(member)
    if member
      'Slack group member'
    else
      'Not a Slack group member'
    end
  end
end
