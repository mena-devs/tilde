FactoryBot.define do
  factory :invitation do
    user
    invitee_name         { 'Hello World' }
    sequence(:invitee_email) { |n| "user-#{n}@example.com" }
    invitee_title        { 'Mr' }
    invitee_company      { 'NASA' }
    invitee_location     { 'FR' }
    invitee_introduction { 'lorem ipsum' }
    delivered            { false }
    registered           { false }
    code_of_conduct      { false }
    member_application   { true }
    created_at           { Time.now }
    updated_at           { Time.now }
    slack_uid            { 'ajshasd' }
    medium               { '' }
    aasm_state           { 'not_sent' }
    retries              { 0 }
  end
end