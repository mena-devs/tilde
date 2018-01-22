# == Schema Information
#
# Table name: profiles
#
#  avatar_content_type          :string
#  avatar_file_name             :string
#  avatar_file_size             :integer
#  avatar_from_slack            :string
#  avatar_from_slack_imported   :boolean          default(FALSE)
#  avatar_from_slack_updated_at :datetime
#  avatar_updated_at            :datetime
#  biography                    :text
#  created_at                   :datetime         not null
#  id                           :integer          not null, primary key
#  interests                    :string
#  location                     :string
#  nickname                     :string
#  privacy_level                :integer          default(0)
#  receive_emails               :boolean          default(FALSE)
#  receive_job_alerts           :boolean          default(FALSE)
#  title                        :string
#  updated_at                   :datetime         not null
#  user_id                      :integer
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Profile < ApplicationRecord
  extend FriendlyId

  friendly_id :nickname

  belongs_to :user

  validates_uniqueness_of :nickname, allow_blank: true

  enum privacy_option: [ "Hidden", "Members only", "Open" ]

  store :interests, accessors: [ :a_new_role, :collaborate_on_a_project, :freelance, :to_mentor_someone, :being_mentored, :participate_at_events ], coder: JSON

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "profile_picture_default.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  validates_with AttachmentSizeValidator, attributes: :avatar, less_than: 1.megabytes

  def complete?
    if (self.user.first_name.blank? ||
        self.user.last_name.blank? ||
        self.location.blank?)
      return false
    else
      return true
    end
  end

  def profile_picture
    return 'profile_picture_default.png' if avatar_from_slack
  end

  def reload_avatar_from_slack
    if user.uid
      user_info_from_slack = SlackApi.get_user_info(user.uid)
      avatar_from_slack = user_info_from_slack['user']['profile']['image_original']
      download_slack_avatar(user_info_from_slack['user']['profile']['image_original'])
    else
      avatar_from_slack = nil
      avatar_from_slack_imported = false
      save
    end
  end

  def download_slack_avatar(avatar_from_slack_url)
    return true if avatar_from_slack_url.blank?

    self.avatar = URI.parse(avatar_from_slack_url).open

    begin
      avatar_from_slack_imported = true
      avatar_from_slack_updated_at = Time.now
      save
    rescue StandardError => e
      logger.error("An error occured while importing an avatar from Slack: #{e}")
    end
  end

  def active_interests
    self.interests.select {|k, v| k if v == "1" }
  end

  def location_name
    unless location.blank?
      country = ISO3166::Country[location]
      (country.translations[I18n.locale.to_s] || country.name) if country
    else
      "Not set yet"
    end
  end
end
