# == Schema Information
#
# Table name: profiles
#
#  id                           :bigint           not null, primary key
#  user_id                      :integer
#  nickname                     :string
#  location                     :string
#  receive_emails               :boolean          default(FALSE)
#  receive_job_alerts           :boolean          default(FALSE)
#  biography                    :text
#  avatar_from_slack            :string
#  privacy_level                :integer          default(0)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  avatar_file_name             :string
#  avatar_content_type          :string
#  avatar_file_size             :integer
#  avatar_updated_at            :datetime
#  avatar_from_slack_imported   :boolean          default(FALSE)
#  avatar_from_slack_updated_at :datetime
#  title                        :string
#  interests                    :string
#  company_name                 :string
#  twitter_handle               :string
#

FactoryBot.define do
  factory :profile do
    user
    sequence(:nickname)               { |n| "kewl-perzon-#{n}" }
    location                          { 'FR' }
    receive_emails                    { false }
    receive_job_alerts                { false }
    biography                         { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. \
                                         Nunc pretium non ex nec dignissim. Vivamus in malesuada ante. \
                                         Vestibulum lobortis sem et sem faucibus, sed varius lectus tincidunt.'
                                      }
    avatar_from_slack                 { 'my_profile_picture.png' }
    privacy_level                     { 0 }
    created_at                        { Time.now }
    updated_at                        { Time.now }
    avatar_file_name                  { 'my_profile_picture.png' }
    avatar_content_type               { 'image/png' }
    avatar_file_size                  { 24 }
    avatar_updated_at                 { Time.now }
    avatar_from_slack_imported        { true }
    avatar_from_slack_updated_at      { Time.now }
    sequence(:title)                  { |n| "job-listing-#{n}" }
    interests                         { { "a_new_role"=>"0", "collaborate_on_a_project"=>"1", "freelance"=>"0", "to_mentor_someone"=>"1" } }
    sequence(:company_name)           { |n| "company-name-#{n}" }
    twitter_handle                    { 'twitter' }
  end
end
