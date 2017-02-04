# == Schema Information
#
# Table name: profiles
#
#  avatar_from_slack  :string
#  biography          :text
#  created_at         :datetime         not null
#  id                 :integer          not null, primary key
#  location           :string
#  nickname           :string
#  privacy_level      :integer          default("Hidden")
#  receive_emails     :boolean          default(FALSE)
#  receive_job_alerts :boolean          default(FALSE)
#  updated_at         :datetime         not null
#  user_id            :integer
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_e424190865  (user_id => users.id)
#

class Profile < ApplicationRecord
  belongs_to :user

  validates_uniqueness_of :nickname

  enum privacy_level: [ "Hidden", "Members only", "Open" ]

  def complete?
    if (user.first_name.nil? &&
        user.last_name.nil? &&
        location.empty?)
      return false
    else
      return true
    end
  end

  def profile_picture
    unless avatar_from_slack
      return 'default_profile_picture.png'
    end

    avatar_from_slack
  end

  def location_name
    if self.location?
      country = ISO3166::Country[self.location]
      country.translations[I18n.locale.to_s] || country.name
    else
      'Lebanon'
    end
  end
end
