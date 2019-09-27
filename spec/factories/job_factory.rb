FactoryBot.define do
  factory :job do
    aasm_state                    { 'approved' }
    sequence(:title)              { |n| "title-#{n}" }
    description                   { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. \
                                      Nunc pretium non ex nec dignissim. Vivamus in malesuada ante. \
                                      Vestibulum lobortis sem et sem faucibus, sed varius lectus tincidunt. \
                                      Sed luctus, enim in viverra hendrerit, mi lectus commodo sapien, et tincidunt orci risus nec enim. \
                                      Donec ornare eros nec eleifend hendrerit. Integer congue ante at efficitur tristique. \
                                      In lacinia tristique nulla in semper. Proin lobortis elementum pulvinar. \
                                      Aliquam mattis lacus quis tellus suscipit tristique. Quisque eget dui quam. \
                                      In ut tortor non nisl condimentum hendrerit. Vivamus ut sem in magna pulvinar iaculis. \
                                      Phasellus venenatis neque quam, et condimentum sem suscipit eu.' }
    external_link                 { 'https://example.com/job' }
    country                       { 'lb' }
    remote                        { false }
    sequence(:custom_identifier)  { |n| "job-listing-#{n}" }
    posted_on                     { Time.now }
    expires_on                    { Time.now }
    posted_to_slack               { false }
    user      
    sequence(:company_name)       { |n| "company-name-#{n}" }
    sequence(:apply_email)        { |n| "user-#{n}@example.com" }
    to_salary                     { 2000 }
    employment_type               { 1 }
    number_of_openings            { 1 }
    experience                    { 2 }
    deleted_at                    { '' }
    created_at                    { Time.now }
    updated_at                    { Time.now }
    from_salary                   { 1000 }
    currency                      { 'USD' }
    education                     { 'professional' }
    payment_term                  { 'per_month' }
    twitter_handle                { '@twitter' }
    sequence(:slug)               { |n| "job-#{n}" }
  end
end