# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
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

class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :last_name, :email

  set_id :custom_identifier

  attribute :nickname do |object|
    object.profile.nickname
  end

  attribute :tilde_url do |object|
    "#{AppSettings.application_host}/directory/users/#{object.custom_identifier}"
  end

  attribute :location do |object|
    object.profile.location
  end

  attribute :biography do |object|
    object.profile.biography
  end

  attribute :title do |object|
    object.profile.title
  end

  attribute :company_name do |object|
    object.profile.company_name
  end

  attribute :twitter_handle do |object|
    object.profile.twitter_handle
  end

  attribute :avatar_url do |object|
    object.profile.avatar.url
  end

  attribute :confirmed do |object|
    object.confirmed?
  end

  attribute :confirmed_at do |object|
    "#{object.confirmed_at}"
  end

  attribute :last_updated do |object|
    "#{object.updated_at}"
  end
end
