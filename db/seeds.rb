# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.new(first_name: "Constantine",
                last_name: "Nicolaou",
                email: "constantin.nicolaou@gmail.com",
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
