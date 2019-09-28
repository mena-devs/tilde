require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  describe "GET /profiles" do
    before(:each) do
      sign_in user
    end

    it "should show user their profile" do
      visit(user_profile_path(user))
      expect(page).to have_content(user.name.titleize)
      expect(page).to have_content('My profile')
      expect(page).to have_content('Logout')
      expect(page).to have_content(user.email)
    end
  end

  describe "PUT /profiles" do
    before(:each) do
      sign_in user
      visit(edit_user_profile_path(user))
    end

    it "should update profile if all required fields are present" do
      expect(page).to have_content('Personal Details')

      select('Lebanon', :from => 'Location', match: :first)
      fill_in('Title',  with: 'Senior Micro Frontend Developer')
      fill_in('Biography',  with: 'This how i ended up working as a micro frontend developer')

      click_on('Update profile', match: :first)

      expect(page).to have_content('Your profile was successfully updated.')
      expect(page).to have_content(user.name.titleize)
    end
  end
end
