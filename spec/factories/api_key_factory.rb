FactoryBot.define do
  factory :api_key do
    access_token           { "" }
    user
    enabled                { true }
    created_at             { Time.now }
    updated_at             { Time.now}
  end
end