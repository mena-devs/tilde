require 'rails_helper'

RSpec.describe "Members", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:admin) { create(:user, admin: true) }
  let!(:user_1) { create(:user, last_name: "yoda") }
  let!(:user_2) { create(:user, last_name: "obi") }
  let!(:user_3) { create(:user, last_name: "darth") }

  describe "GET /index" do
    describe "Admin login" do
      before(:each) do
        sign_in admin
      end

      it "should display all members to admin" do
        visit(members_path)

        expect(page).to have_content(user_1.name)
        expect(page).to have_content(user_2.name)
        expect(page).to have_content(user_3.name)
        expect(page).to have_content('My Account')
        expect(page).to have_content('Logout')
      end
    end

    describe "Regular user login" do
      before(:each) do
        sign_in user_1
      end

      it "should not allow displaying data to non-admin" do
        visit(members_path)

        expect(page).not_to have_content(user_2.name)
        expect(page).not_to have_content(user_3.name)
        expect(page).to have_content('My Account')
        expect(page).to have_content('Logout')
      end
    end
  end
end
