# # Create users
# user = User.new(first_name: "Constantine",
#                 last_name: "Nicolaou",
#                 email: "constantin.nicolaou@gmail.com",
#                 admin: true,
#                 password: "password",
#                 password_confirmation: "password")
#
# user.skip_confirmation!
# user.save!
#
# profile = user.profile
# profile.privacy_level = Profile.privacy_options["Open"]
# profile.save

# user_1 = User.new(first_name: "User",
#                   last_name: "One",
#                   email: "user.one@example.com",
#                   password: "password",
#                   password_confirmation: "password")
#
# user_1.skip_confirmation!
# user_1.save!
# user_1.reload
#
# puts user_1.inspect
#
# profile = user_1.profile
# profile.privacy_level = Profile.privacy_options["Open"]
# profile.save
#
# user_2 = User.new(first_name: "User",
#                 last_name: "Two",
#                 email: "user.two@example.com",
#                 password: "password",
#                 password_confirmation: "password")
#
# user_2.skip_confirmation!
# user_2.save!
# user_2.reload
#
# puts user_2.profile.inspect
#
# profile = user_2.profile
# profile.privacy_level = Profile.privacy_options["Open"]
# profile.save

# Create jobs
# job_params = {
#   title: "Software developer",
#   description: "You should be a kick-ass developer",
#   job_description_location: "http://www.keeward.com",
#   location: "LB",
#   remote_ok: true,
#   posted_on: Time.now,
#   posted_to_slack: false,
#   user_id: user.id,
#   company_name: "Keeward",
#   apply_email: "hr@example.com",
#   salary: nil,
#   job_type: "internship",
#   number_of_openings: 1,
#   level: "no_experience"
# }
#
# job = Job.create(job_params)
# job.post_online!
