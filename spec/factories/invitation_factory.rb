# == Schema Information
#
# Table name: invitations
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  invitee_name         :string
#  invitee_email        :string
#  invitee_title        :string
#  invitee_company      :string
#  invitee_location     :string
#  invitee_introduction :text
#  delivered            :boolean          default(FALSE)
#  registered           :boolean          default(FALSE)
#  code_of_conduct      :boolean          default(FALSE)
#  member_application   :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  slack_uid            :string
#  medium               :string
#  aasm_state           :string
#  retries              :integer          default(0)
#

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
