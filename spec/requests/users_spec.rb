require 'rails_helper'

RSpec.describe "Users", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:open_profile_member) { create(:user, first_name: 'georges', last_name: 'groot') }
  let(:member) { create(:user, first_name: 'alexander', last_name: 'adam') }

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
end