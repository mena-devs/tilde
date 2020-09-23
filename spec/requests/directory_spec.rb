require 'rails_helper'

RSpec.describe "Directory", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:admin) { create(:user, admin: true) }
  let!(:user_1) { create(:user, first_name: "yoko", last_name: "ono") }
  let!(:user_2) { create(:user, first_name: "obi", last_name: "kanobi") }
  let!(:user_3) { create(:user, first_name: "darth", last_name: "vader") }

  describe "Directory members" do
    before do
      profile = user_1.profile
      profile.a_new_role = "1"
      profile.privacy_level = 2
      profile.save
      user_2.profile.update(privacy_level: 2)
    end

    it "should be able to view members" do
      visit(directory_users_path)

      expect(page).to have_content(user_1.name)
      expect(page).to have_content(user_2.name)

      expect(page).to have_content('Looking for a new role')
      expect(page).to have_content('Available for freelance')
      expect(page).to have_content('Available to mentor')
      expect(page).to have_content('Looking for a mentor')
    end

    describe "Filtering" do
      it "should be able to filter based on alphabet letter" do
        visit(directory_users_path(name: 'y'))

        expect(page).to have_content(user_1.name)
        expect(page).not_to have_content(user_2.name)

        expect(page).to have_content('A')
        expect(page).to have_content('B')
      end
    end

    describe "Interests" do
      it "should be able to filter based on interest#new_role" do
        visit(directory_users_path(state: 'new_role'))

        expect(page).to have_content(user_1.name)
        expect(page).not_to have_content(user_2.name)

        expect(page).to have_content('Looking for a new role')
        expect(page).to have_content('Available for freelance')
      end

      it "should be able to filter based on interest#freelanc" do
        visit(directory_users_path(state: 'freelance'))

        expect(page).not_to have_content(user_1.name)
        expect(page).not_to have_content(user_2.name)

        expect(page).to have_content('Looking for a new role')
        expect(page).to have_content('Available for freelance')
      end
    end
  end
end
