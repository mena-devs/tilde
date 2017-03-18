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

  after_create :prepare_profile

  def self.from_omniauth(auth)
    logger.info("Information returned from SLACK API")
    logger.info(auth.inspect)

    if auth['info']['team'].downcase != 'mena developers' &&
      auth['info']['team_id'] != 'T03B400RJ'
      return false
    end

    user_exists = where(email: auth.info.email).first

    if user_exists
      begin
        user_exists.update(provider: auth.provider, uid: auth.uid)
      rescue Exception => e
        logger.info(e)
      end
      return user_exists
    else
      begin
        where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
          user.provider = auth.provider
          user.uid = auth.uid
          user.email = auth.info.email
          user.first_name = auth.info.first_name
          user.last_name = auth.info.last_name
          user.time_zone = auth.info.time_zone
          user.auth_token = auth.credentials.token
          user.password = Devise.friendly_token[0,20]

          user.build_profile(avatar_from_slack: auth.info.image,
                             biography: auth.info.description)
          user.skip_confirmation! if user.new_record?
        end
      rescue Exception => e
        logger.info(e)
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
      self.create_profile
    end
end
