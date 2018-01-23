# == Schema Information
#
# Table name: users
#
#  active                 :boolean          default(TRUE)
#  admin                  :boolean          default(FALSE)
#  auth_token             :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  custom_identifier      :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  id                     :integer          not null, primary key
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  time_zone              :string
#  uid                    :string
#  unconfirmed_email      :string
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_custom_identifier     (custom_identifier) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_provider              (provider)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid                   (uid)
#

class User < ApplicationRecord
  extend FriendlyId

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:slack]

  validates :email, uniqueness: true
  validates :email, format: {
                      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                      on: :create }

  before_validation :generate_unique_user_id, on: :create

  friendly_id :custom_identifier

  has_one :profile, :dependent => :destroy
  has_many :jobs, :dependent => :destroy
  has_many :api_keys, :dependent => :destroy

  after_create :prepare_profile
  after_save :prepare_profile

  scope :job_alert_subscribers, -> { joins(:profile).where('profiles.receive_job_alerts = ?', true) }
  scope :verified, -> { where("confirmed_at IS NOT NULL")}

  scope :open_profile, -> { joins(:profile).where('profiles.privacy_level = ?', Profile.privacy_options["Open"]) }

  scope :members_profile, -> { joins(:profile).where('profiles.privacy_level = ? or profiles.privacy_level = ?', Profile.privacy_options["Members only"], Profile.privacy_options["Open"]) }

  def self.default_scope
    where(active: true)
  end

  def new_from_slack_oauth(user_info)
    begin
      self.provider     = user_info.provider
      self.uid          = user_info.uid
      self.email        = user_info.info.email
      self.first_name   = user_info.info.first_name
      self.last_name    = user_info.info.last_name
      self.time_zone    = user_info.info.time_zone
      self.auth_token   = user_info.credentials.token
      self.password     = Devise.friendly_token[0,20]
      self.confirmed_at = Time.now

      if self.valid?
        profile = self.build_profile(biography: user_info.info.description,
                                     title: user_info.info.title)
        profile.download_slack_avatar(user_info.info.image)
      end

      return self
    rescue Exception => e
      logger.error("An error that has occured while intialising a user from Slack --")
      logger.error(e)
    end
  end

  def self.new_from_slack_token(user_info)
    begin
      user = User.new
      user.uid        = user_info['user']['id']
      user.email      = user_info['user']['profile']['email']
      user.first_name = user_info['user']['profile']['first_name']
      user.last_name  = user_info['user']['profile']['last_name']
      user.time_zone  = user_info['user']['tz']
      user.password   = Devise.friendly_token[0,20]

      if user.valid?
        profile = user.build_profile(biography: user_info['user']['profile']['description'],
                                     title: user_info['user']['profile']['title'])
        profile.download_slack_avatar(user_info['user']['profile']['image_original'])
      end

      return user
    rescue Exception => e
      logger.error("An error that has occured while creating a user from token --")
      logger.error(e)
    end
  end

  def self.find_user_by_slack_uid(slack_uid)
    user = find_by_uid(slack_uid)

    if user.blank?
      user_info_from_slack = SlackApi.get_user_info(slack_uid)
      user = User.new_from_slack_token(user_info_from_slack)
      user.skip_confirmation! if user.new_record?
      user.save
    end

    user
  end

  def self.from_omniauth(auth)
    if auth['info']['team_id'] != AppSettings.slack_team_id
      return false
    end

    user = find_by_email(auth.info.email)

    if user.blank?
      user = User.where(provider: auth.provider, uid: auth.uid).first

      logger.info(">>>> Found user #{user.inspect} <<<<") if user

      if user.blank?
        user = User.new
        user = user.new_from_slack_oauth(auth)
        user.provider = auth.provider
        user.uid = auth.uid
        user.active = true
        user.save
        logger.info(">>>> Created new user #{user.inspect} <<<<")
      end
    else
      user.update(provider: auth.provider,
                  uid: auth.uid,
                  auth_token: auth.credentials.token)
      logger.info(">>>> User #{auth.info.email} logged in <<<<")
    end

    user
  end

  def self.update_user_from_slack(user_info)
    unless User.unscoped.exists?(email: user_info['profile']['email'])
      user = User.new(
        uid: user_info['id'],
        email: user_info['profile']['email'],
        first_name: user_info['profile']['first_name'],
        last_name: user_info['profile']['last_name'],
        time_zone: user_info['tz'],
        password: Devise.friendly_token[0,20],
        confirmed_at: Time.now,
        active: false
      )

      if user.valid?
        profile = user.build_profile(biography: user_info['profile']['description'],
                                     nickname: user_info['profile']['display_name'],
                                     title: user_info['profile']['title'])
        profile.download_slack_avatar(user_info['profile']['image_original'])

        user.save
      end
    end
  end

  def name
    if self.first_name.nil? && self.last_name.nil?
      return ""
    else
      self.first_name + ' ' + self.last_name
    end
  end

  def connected_via_slack?
    self.provider == 'slack' && self.uid.present?
  end

  def disconnect_slack
    self.provider = nil
    self.uid = nil
    self.auth_token = nil
  end

  private
    def generate_unique_user_id
      self.custom_identifier = Digest::SHA1.hexdigest(Time.now.to_s + rand(12341234).to_s + "#{self.email}")[1..24]
    end

    def prepare_profile
      self.create_profile if self.profile.nil?
    end
end
