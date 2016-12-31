# == Schema Information
#
# Table name: profiles
#
#  avatar_from_slack  :string
#  biography          :text
#  created_at         :datetime         not null
#  id                 :integer          not null, primary key
#  location           :string
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

  def location_name
    country = ISO3166::Country[self.location]
    country.translations[I18n.locale.to_s] || country.name
  end
end
