module ApplicationHelper
  def flash_class(level)
    case level
      when ('notice' || :notice) then "style-msg successmsg"
      when ('success' || :success) then "style-msg successmsg"
      when ('error' || :error) then "style-msg errormsg"
      when ('alert' || :alert) then "style-msg errormsg"
    end
  end

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

  def user_can_join_slack?
    if user_signed_in?
      # If the user isn't already connected via slack or
      # sent an invitation to join that is pending or approved
      if (current_user.connected_via_slack? || Invitation.has_pending_invitation_to_join_slack(current_user.email))
        return false
      end
    end

    return true
  end

  def boolean_icon(objkt)
    if objkt
      fa_icon('check')
    else
      fa_icon('times')
    end
  end

  def directory_letters
    letters = ('a'..'z').to_a.map.each do |letter|
      link_to(directory_users_path(name: letter)) do
        content_tag(:button, class: 'button button-directory button-3d button-mini button-rounded button-teal') do
          letter.capitalize
        end
      end
    end
    letters.join('').html_safe
  end
end
