# == Schema Information
#
# Table name: admins
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
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryBot.define do
  factory :admin do
    sequence(:email)       { |n| "admin-#{n}@example.com" }
    password               { '12345678' }
    sequence(:reset_password_token) { |n| "random-#{n}-reset-password-{n-1}-hey" }
    reset_password_sent_at { '' }
    remember_created_at    { '' }
    sign_in_count          { 0 }
    current_sign_in_at     { '' }
    last_sign_in_at        { '' }
    current_sign_in_ip     { '' }
    last_sign_in_ip        { '' }
    created_at             { Time.now }
    updated_at             { Time.now}
  end
end
