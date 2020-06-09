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

      expect(page).to have_content('Personal email and password')
      expect(page).to have_content('Email')
      expect(page).to have_content('Password')
    end

    it "should login successfully using email and password" do
      fill_in 'Email', with: user.email
      fill_in 'Password',  with: 'password'

      click_on('Log in')

      expect(page).to have_content("My profile")
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
      visit directory_users_path
      click_on('G', match: :first)

      expect(page).to have_content('Members Directory')
      expect(page).to have_content(open_profile_member.name)
    end

    it "should list members with members only and OPEN profiles" do
      sign_in user
      visit directory_users_path
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
        expect(page).to have_content('My profile')
        expect(page).to have_content('Logout')
      end
    end
  end
end