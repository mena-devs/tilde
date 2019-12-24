# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  provider               :string
#  uid                    :string
#  auth_token             :string
#  first_name             :string
#  last_name              :string
#  time_zone              :string
#  admin                  :boolean          default(FALSE)
#  custom_identifier      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  active                 :boolean          default(TRUE)
#  email_reminders        :string
#

class User < ApplicationRecord
  extend FriendlyId

  attr_writer :login

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
  has_many :job_statistic

  after_create :prepare_profile
  after_save :prepare_profile

  scope :job_alert_subscribers, -> { joins(:profile).where('profiles.receive_job_alerts = ?', true) }
  scope :verified, -> { where("confirmed_at IS NOT NULL")}

  scope :open_profile, -> { joins(:profile).where('profiles.privacy_level = ?', Profile.privacy_options["Open"]) }

  scope :members_profile, -> { joins(:profile).where('profiles.privacy_level = ? or profiles.privacy_level = ?', Profile.privacy_options["Members only"], Profile.privacy_options["Open"]) }

  store :email_reminders, accessors: [ :complete_profile ], coder: JSON

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
      logger.error("An error has occured while intialising a user from Slack: {e}")
      raise e
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
      logger.error("An error that has occured while creating a user from token: {e}")
      raise e
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

      if user.blank?
        user = User.new
        user = user.new_from_slack_oauth(auth)
        user.provider = auth.provider
        user.uid = auth.uid
        user.active = true
        user.save
      end
    else
      user.update(provider: auth.provider,
                  uid: auth.uid,
                  auth_token: auth.credentials.token)
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
      end

      return user.save
    end
    
    return false
  end

  def name
    if self.first_name.blank? && self.last_name.blank?
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

  def self.email_new_users_with_incomplete_profiles
    verified.joins(:profile).where('users.first_name is NULL and users.last_name is NULL and profiles.location is NULL and users.created_at >= ?', 5.days.ago).each do |user|
      UserMailer.complete_profile(user.custom_identifier).deliver
      user.complete_profile = true
      user.save
    end
  end

  def self.delete_unverified_accounts
    unscoped.where('confirmed_at IS NULL and unconfirmed_email IS NOT NULL and created_at >= ?', 3.days.ago).each do |user|
      user.destroy
    end
  end

  def self.email_notifications(subject)
    User.job_alert_subscribers.each do |user|
      NotificationsMailer.announcement(user.id, subject).deliver_later
    end
  end

  private
    def generate_unique_user_id
      self.custom_identifier = Digest::SHA1.hexdigest(Time.now.to_s + rand(12341234).to_s + "#{self.email}")[1..24]
    end

    def prepare_profile
      self.create_profile if self.profile.nil?
    end
end
