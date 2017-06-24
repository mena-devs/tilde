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
end
