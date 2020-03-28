module MembersHelper
  def complete_profile(profile)
    profile ? "Yes" : "No"
  end

  def display_provider(provider)
    provider ? provider.titleize : "Email"
  end

  def display_user_name(user)
    user.name.blank? ? details = "(Name not set yet)" : details = user.name
  end

  def display_user_description(biography)
    biography.blank? ? "Biography not set yet" : truncate(biography, length: 200, omission: '...')
  end
end