# == Schema Information
#
# Table name: users
#
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

  def new_from_slack_oauth(user_info)
    self.provider   = user_info.provider
    self.uid        = user_info.uid
    self.email      = user_info.info.email
    self.first_name = user_info.info.first_name
    self.last_name  = user_info.info.last_name
    self.time_zone  = user_info.info.time_zone
    self.auth_token = user_info.credentials.token
    self.password   = Devise.friendly_token[0,20]

    if self.valid?
      self.build_profile(avatar_from_slack: user_info.info.image,
                         biography: user_info.info.description)
    end

    self.skip_confirmation! if self.new_record?

    self
  end

  def self.new_from_slack_token(user_info)
    user = User.new
    user.uid        = user_info['user']['id']
    user.email      = user_info['user']['profile']['email']
    user.first_name = user_info['user']['profile']['first_name']
    user.last_name  = user_info['user']['profile']['last_name']
    user.time_zone  = user_info['user']['tz']
    user.password   = Devise.friendly_token[0,20]

    if user.valid?
      user.build_profile(avatar_from_slack: user_info['user']['profile']['image_original'],
                         biography: user_info['user']['profile']['title'])
    end

    user
  end

  def self.find_user_by_slack_uid(slack_uid)
    user = where(uid: slack_uid).first

    if user.blank?
      user_info_from_slack = SlackApi.get_user_info(slack_uid)
      user = User.new_from_slack_token(user_info_from_slack)
      user.skip_confirmation! if user.new_record?
      user.save
    end

    user
  end

  def self.from_omniauth(auth)
    logger.info("Information returned from SLACK API")
    logger.info(auth.inspect)

    if auth['info']['team_id'] != AppSettings.slack_team_id
      return false
    end

    user = where(email: auth.info.email).first

    if user
      begin
        user.update(provider: auth.provider,
                    uid: auth.uid,
                    auth_token: auth.credentials.token)
        user.skip_confirmation! if user.confirmed_at.blank?
      rescue Exception => e
        logger.info(e)
      end
    else
      begin
        user = where(provider: auth.provider, uid: auth.uid).first_or_create do |u|
          u.new_from_slack_oauth(auth)
        end
      rescue Exception => e
        logger.info(e)
      end
    end

    user
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
