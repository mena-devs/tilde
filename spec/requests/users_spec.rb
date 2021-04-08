require 'rails_helper'

RSpec.describe "Users", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:admin) { create(:user, admin: true) }
  let!(:user) { create(:user, password: 'password') }
  let(:open_profile_member) { create(:user, first_name: 'georges', last_name: 'groot') }
  let(:member) { create(:user, first_name: 'alexander', last_name: 'adam') }

  describe "GET /users/sign_in" do
    before do
      visit new_user_session_path

      expect(page).to have_content('Login with your email and password')
      expect(page).to have_content('Email')
      expect(page).to have_content('Password')
    end

    it "should login successfully using email and password" do
      fill_in 'Email', with: user.email
      fill_in 'Password',  with: 'password'

      click_on('Log in')

      expect(page).to have_content("My Account")
      expect(page).to have_content("Logout")
    end

    it "should not allow login if email does not exist" do
      fill_in 'Email', with: 'something@example.com'
      fill_in 'Password',  with: 'password'

      click_on('Log in')

      expect(page).to have_content('Email')
      expect(page).to have_content('Password')
    end
  end
  
  # /users/password/new
  describe "GET /users/password/new" do
    before do
      visit new_user_password_path

      expect(page).to have_content('Forgot your password?')
      expect(page).to have_content('Type your email address')
      expect(page).to have_content('Email')
    end

    it "should not allow to submit form without valid email" do
      click_on('Send me reset password instructions')

      expect(page).to have_content("1 error prohibited this user from being saved")
      expect(page).to have_content("Email can't be blank")
    end

    it "should submit a form to request password reset for an account" do
      fill_in 'Email', with: user.email

      click_on('Send me reset password instructions')

      expect(page).to have_content("Use any of the login options below to login")
      expect(page).to have_content("MENAdevs Slack credentials")
      expect(page).to have_content("Login with your email and password")
    end
  end

  # /users/password/edit?reset_password_token=
  describe "GET /users/password/edit" do
    it "should not allow reset of password if the password is not matching" do
      visit edit_user_password_path(reset_password_token: user.reset_password_token)
      
      expect(page).to have_content('Change your password')
      expect(page).to have_content('Type your new password')
      expect(page).to have_content('Password')
      expect(page).to have_content('Password confirmation')

      click_on('Change my password')

      expect(page).to have_content("1 error prohibited this user from being saved")
      expect(page).to have_content("Reset password token is invalid")
    end

    it "should not allow reset password if the token is not valid" do
      visit edit_user_password_path(reset_password_token: user.reset_password_token)
      
      expect(page).to have_content('Change your password')
      expect(page).to have_content('Type your new password')
      expect(page).to have_content('Password')
      expect(page).to have_content('Password confirmation')

      fill_in 'Password', with: 'opensource'
      fill_in 'Password confirmation', with: 'opensource'

      click_on('Change my password')

      expect(page).to have_content("Reset password token is invalid")
    end

    it "should successfully reset password for an account" do
      reset_password_token = user.send_reset_password_instructions

      user.reset_password_sent_at = Time.now
      user.save

      visit edit_user_password_path(reset_password_token: reset_password_token)
      
      expect(page).to have_content('Change your password')
      expect(page).to have_content('Type your new password')
      expect(page).to have_content('Password')
      expect(page).to have_content('Password confirmation')

      fill_in 'Password', with: 'OpenSource'
      fill_in 'Password confirmation', with: 'OpenSource'

      click_on('Change my password')
      
      expect(page).to have_content("We are MENA Devs")
      expect(page).to have_content("one of the largest active online communities in the MENA region")
    end
  end

  describe "GET /users/sign_in" do
    before do
      visit new_user_session_path

      expect(page).to have_content('Login with your email and password')
      expect(page).to have_content('Email')
      expect(page).to have_content('Password')
    end

    it "should login successfully using email and password" do
      fill_in 'Email', with: user.email
      fill_in 'Password',  with: 'password'

      click_on('Log in')

      expect(page).to have_content("My Account")
      expect(page).to have_content("Logout")
    end

    it "should not allow login if email does not exist" do
      fill_in 'Email', with: 'something@example.com'
      fill_in 'Password',  with: 'password'

      click_on('Log in')

      expect(page).to have_content('Email')
      expect(page).to have_content('Password')
    end
  end

  describe "GET /directory/users" do
    before do
      create(:profile, user: open_profile_member, privacy_level: 2)
      create(:profile, user: member, privacy_level: 1)
    end

    it "should list members with OPEN profiles" do
      visit(directory_users_path)
      click_button('G')

      expect(page).to have_content('Members Directory')
      expect(page).to have_content(open_profile_member.name)
    end

    it "should list members with members only and OPEN profiles" do
      sign_in(user)
      visit(directory_users_path)
      click_on('ALL', match: :first)

      expect(page).to have_content('Members Directory')
      expect(page).to have_content(open_profile_member.name)
      expect(page).to have_content(member.name)
    end
  end

  describe "GET /directory/users/:id" do
    describe "Regular user login" do
      before do
        create(:profile, user: open_profile_member, privacy_level: 2)
        create(:profile, user: member, privacy_level: 1)
      end

      it "should show member with OPEN profile" do
        visit directory_user_path(open_profile_member)

        expect(page).to have_content('Personal Details')
        expect(page).to have_content(open_profile_member.name.titleize)
      end

      it "should show member with members only profile" do
        sign_in user
        visit directory_user_path(member)

        expect(page).to have_content('Professional Experience and Interests')
        expect(page).to have_content(member.name.titleize)
      end
    end

    describe "Admin login" do
      before(:each) do
        create(:profile, user: open_profile_member, privacy_level: 2)
        create(:profile, user: member, privacy_level: 1)
        sign_in admin
      end

      it "should display member's details to admin" do
        visit(directory_user_path(open_profile_member))

        expect(page).to have_content(open_profile_member.email)
        expect(page).to have_content(open_profile_member.name.titleize)
        expect(page).not_to have_content(member.email)
        expect(page).to have_content('My Account')
        expect(page).to have_content('Logout')
      end
    end
  end
end