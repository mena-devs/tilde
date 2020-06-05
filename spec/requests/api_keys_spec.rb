require 'rails_helper'

RSpec.describe "ApiKeys", type: :request do
  include Devise::Test::IntegrationHelpers

  let!(:user) { create(:user) }
  let!(:admin) { create(:user, admin: true) }
  let!(:api_key) { create(:api_key, user: user) }
  let!(:deleted_api_key) { create(:api_key, user: admin, deleted_at: Time.now) }

  describe "GET /private/api_keys" do
    it "should list all undeleted API Keys" do
      sign_in admin
      visit private_api_keys_path

      expect(page).to have_http_status(200)
      expect(page).to have_content(api_key.id)
      expect(page).to_not have_content(deleted_api_key.user.name)
    end

    it "should not allow unauthorised access" do
      sign_in user
      visit private_api_keys_path

      expect(page).to have_http_status(200)
      expect(page).to have_content("We are MENA Devs")
      expect(page).to have_content("What is MENAdevs")

      expect(page).to_not have_content(api_key.user.name)
      expect(page).to_not have_content(deleted_api_key.user.name)
    end
  end

  describe "PATCH/PUT /private/api_keys/:id/update_state" do
    it "should update state of API Key" do
      sign_in admin
      visit private_api_keys_path

      expect(page).to have_http_status(200)
      expect(page).to have_content(api_key.user.name.titleize)
      expect(page).to have_content('Active')

      click_on 'Disable'

      expect(page).to have_content('Disabled')
      expect(page).to have_content('Enable')
      expect(page).to have_content('API Key state was successfully updated.')
    end
  end

  describe "PATCH/PUT /private/api_keys/:id/update_access" do
    it "should update access type of API Key" do
      sign_in admin
      visit private_api_keys_path

      expect(page).to have_http_status(200)
      expect(page).to have_content(api_key.user.name.titleize)
      expect(page).to have_content('read')
      expect(page).to have_content('Change to Read/Write')

      click_on 'Change to Read/Write'

      expect(page).to have_content('read_write')
      expect(page).to have_content('Change to Read')
      expect(page).to have_content('API Key access type was successfully updated.')
    end
  end
end