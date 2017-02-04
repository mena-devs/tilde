# Create users
user = User.new(first_name: "Constantine",
                last_name: "Nicolaou",
                email: "constantin.nicolaou@gmail.com",
                admin: true,
                password: "password",
                password_confirmation: "password")

user.skip_confirmation!
user.save

user.profile.privacy_level = Profile.privacy_levels["Open"]
user.profile.save

user = User.new(first_name: "User",
                last_name: "One",
                email: "user.one@example.com",
                password: "password",
                password_confirmation: "password")

user.skip_confirmation!
user.save

user.profile.privacy_level = Profile.privacy_levels["Open"]
user.profile.save

user = User.new(first_name: "User",
                last_name: "Two",
                email: "user.two@example.com",
                password: "password",
                password_confirmation: "password")

user.skip_confirmation!
user.save

user.profile.privacy_level = Profile.privacy_levels["Open"]
user.profile.save

# Create jobs
job_params = {
  title: "Software developer",
  description: "You should be a kick-ass developer",
  job_description_location: "http://www.keeward.com",
  location: "LB",
  remote_ok: true,
  posted_on: Time.now,
  posted_to_slack: false,
  user_id: user.id,
  company_name: "Keeward",
  apply_email: "hr@example.com",
  salary: nil,
  job_type: "internship",
  number_of_openings: 1,
  level: "no_experience"
}

job = Job.create(job_params)
job.post!
