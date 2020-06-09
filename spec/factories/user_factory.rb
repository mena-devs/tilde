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

FactoryBot.define do
  factory :user do
    sequence(:email)       { |n| "user-#{n}@example.com" }
    password               { '12345678' }
    sequence(:reset_password_token) { |n| "random-#{n}-reset-password-{n-1}-hey" }
    reset_password_sent_at { '' }
    remember_created_at    { '' }
    sign_in_count          { 0 }
    current_sign_in_at     { '' }
    last_sign_in_at        { '' }
    current_sign_in_ip     { '' }
    last_sign_in_ip        { '' }
    sequence(:confirmation_token) { |n| "random-#{n}confirmation-token-{n+1}-hey" }
    confirmed_at           { Time.now }
    confirmation_sent_at   { '' }
    unconfirmed_email      { '' }
    provider               { '' }
    sequence(:uid)         { |n| "#{n}" }
    auth_token             { '' }
    first_name             { 'user' }
    last_name              { 'one' }
    time_zone              { 'Amsterdam' }
    admin                  { false }
    sequence(:custom_identifier) { |n| "user-#{n}" }
    created_at             { Time.now }
    updated_at             { Time.now}
    active                 { true }
    email_reminders        { '' }
  end
end
