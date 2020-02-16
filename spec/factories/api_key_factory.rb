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
    access_token           { "" }
    user
    enabled                { true }
    created_at             { Time.now }
    updated_at             { Time.now}
  end
end
