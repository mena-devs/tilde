# == Schema Information
#
# Table name: api_keys
#
#  id           :bigint           not null, primary key
#  access_token :string
#  user_id      :integer
#  enabled      :boolean          default(TRUE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :api_key do
    sequence(:access_token) { |n| "api-token-#{n}-random-{n-1}-hey" }
    user
    enabled                { true }
    created_at             { Time.now }
    updated_at             { Time.now}
  end
end
