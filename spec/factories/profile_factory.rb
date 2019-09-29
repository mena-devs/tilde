FactoryBot.define do
  factory :profile do
    user
    sequence(:nickname)               { |n| "kewl-perzon-#{n}" }
    location                          { 'LB' }
    receive_emails                    { false }
    receive_job_alerts                { false }
    biography                         { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. \
                                         Nunc pretium non ex nec dignissim. Vivamus in malesuada ante. \
                                         Vestibulum lobortis sem et sem faucibus, sed varius lectus tincidunt.'
                                      }
    avatar_from_slack                 {'my_profile_picture.png' }
    privacy_level                     { 0 }
    created_at                        { Time.now }
    updated_at                        { Time.now }
    avatar_file_name                  { 'my_profile_picture.png' }
    avatar_content_type               { 'image/png' }
    avatar_file_size                  { 24 }
    avatar_updated_at                 { Time.now }
    avatar_from_slack_imported        { false }
    avatar_from_slack_updated_at      { Time.now }
    sequence(:title)                  { |n| "job-listing-#{n}" }
    interests                         { 'collaborate_on_a_project, freelance' }
    sequence(:company_name)           { |n| "company-name-#{n}" }
    twitter_handle                    { 'twitter' }
  end
end