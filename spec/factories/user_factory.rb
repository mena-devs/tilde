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