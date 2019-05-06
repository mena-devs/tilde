module ProfilesHelper
  def name(profile)
    profile.user.name.titleize
  end

  def email(profile)
    profile.user.email
  end

  def nickname(profile)
    if profile.nickname.blank?
      "<strong>not-set</strong>".html_safe
    else
      profile.nickname.downcase
    end
  end

  def location(profile)
    profile.location_name
  end

  def biography(profile)
    if profile.biography.blank?
      "<strong>Biography is not set</strong>".html_safe
    else
      profile.biography.html_safe
    end
  end

  def privacy_info_icon(profile)
    if @profile.privacy_level == 0
      fa_icon("eye-slash", text: 'Hidden')
    elsif @profile.privacy_level == 1
      fa_icon("adjust", text: 'Members-only')
    elsif @profile.privacy_level == 2
      fa_icon("eye", text: 'Open')
    end
  end

  def privacy_info_message(profile)
    if @profile.privacy_level == 0
      "Your profile is not visible to anyone"
    elsif @profile.privacy_level == 1
      "Your profile is visible to members of menadevs.com"
    elsif @profile.privacy_level == 2
      "Your profile is public & searchable"
    end
  end

  def notification_message(notification)
    if notification
      fa_icon("check")
    else
      fa_icon("close")
    end
  end
end
