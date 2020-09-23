module ApplicationHelper
  def flash_class(level)
    case level
      when ('notice' || :notice) then "style-msg successmsg"
      when ('success' || :success) then "style-msg successmsg"
      when ('error' || :error) then "style-msg errormsg"
      when ('alert' || :alert) then "style-msg errormsg"
    end
  end

  def user_name(user)
    name = user.try(:name)
    if name.blank?
      name = " - Not defined -"
    else
      name = name.titleize
    end

    link_to(name, directory_user_path(user))
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

  def directory_letters(selected_letter=nil)
    unless selected_letter.nil?
      selected_letter = selected_letter.downcase.strip
    end

    letters = ('a'..'z').to_a.map.each do |letter|
      link_to(directory_users_path(name: letter)) do
        content_tag(:button, class: button_style(selected_letter == letter)) do
          letter.capitalize
        end
      end
    end
    letters.join('').html_safe
  end

  def button_style(selected=false)
    unselected_style_class = 'button button-directory button-3d button-mini button-rounded'
    select_style_class = unselected_style_class + ' button-teal'
    
    selected ? select_style_class : unselected_style_class
  end

  def display_member_description(user)
    biography = user.profile.try(:biography)

    if biography.blank?
      return content_tag(:p, "Profile description is not set", class: "member_profile_invalid" )
    end

    content_tag(:p) do
      truncate(biography, length: 280, omission: ' ... ') { link_to "Read more", directory_user_path(user) }
    end
  end

  def display_member_details_inline(user)
    member_details_one_liner = ""
    
    if user.profile.title
      member_details_one_liner += user.profile.title
    end

    if user.profile.company_name && !user.profile.company_name.empty?
      member_details_one_liner += ", at #{user.profile.company_name}"
    end

    content_tag(:p, member_details_one_liner, class: "member_profile")
  end

  def authorised_admin?
    (user_signed_in? && current_user.admin?)
  end

  def display_button_filter_class(parameters, state=nil)
    class_data = 'button button-directory button-3d button-mini button-rounded'
    
    if (state.nil? && !parameters.has_key?(:state))
      class_data += ' button-teal'
    elsif (!state.nil? && parameters[:state] == state)
      class_data += ' button-teal'
    end

    class_data
  end
end
