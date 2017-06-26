module ApplicationHelper
  def is_user_a_slack_member?(member)
    if member
      'Slack group member'
    else
      'Not a Slack group member'
    end
  end

  def display_time_zone(time_zone)
    if !time_zone.nil?
      return ActiveSupport::TimeZone[time_zone]
    else
      return ActiveSupport::TimeZone['Athens']
    end
  end

  def visible_profile?(user)
    if user.profile && user.profile.complete?
      case Profile.privacy_options[user.profile.privacy_level]
      when 0
        return false
      when 1
        return true
      when 2
        return true
      end
    end
  end

  def boolean_icon(objkt)
    if objkt
      fa_icon('check')
    else
      fa_icon('times')
    end
  end
end
