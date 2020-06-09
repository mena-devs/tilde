require 'rails_helper'

RSpec.describe "Invitations", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  describe "GET /invitations" do
    before(:each) do
      @invitation = create(:invitation, user: user, code_of_conduct: true)
      sign_in user
    end

    it "should list all invitations" do
      get invitations_path
      expect(response).to have_http_status(200)
      expect(response.body).to include(@invitation.invitee_name)
    end
  end

  describe "POST /invitations" do
    it "should allow new user to send invitation to join Slack group" do
      sign_in user
      visit new_invitation_path
      expect(page).to have_content('Apply to join')
      expect(page).to have_content('Send invitation to someone else')

      click_on('Apply to join')

      find('textarea.introduction-internal').set('You will face many defeats in life, but never let yourself be defeated.')
      first('input#invitation_code_of_conduct').check
      first('input#slack_apply_form_button').click

      expect(page).to have_content('Your application was received and will be processed shortly.')
    end

    it "should allow a member to invitate others to join Slack group" do
      sign_in user
      visit new_invitation_path
      expect(page).to have_content('Apply to join')
      expect(page).to have_content('Send invitation to someone else')

      click_on('Send invitation to someone else')

      fill_in('Email', with: 'user.one@example.com')
      fill_in('Full Name', with: 'User One')
      find('textarea.introduction-external').set('You will face many defeats in life, but never let yourself be defeated.')
      all('input#invitation_code_of_conduct').last.check
      find('input#slack_invitation_form_button').click

      expect(page).to have_content('Your application was received and will be processed shortly.')
    end

    it "should not allow a member to invitate others to join Slack group" do
      sign_in user
      visit new_invitation_path
      expect(page).to have_content('Apply to join')
      expect(page).to have_content('Send invitation to someone else')

      click_on('Send invitation to someone else')

      find('textarea.introduction-external').set('You will face many defeats in life, but never let yourself be defeated.')
      all('input#invitation_code_of_conduct').last.check
      find('input#slack_invitation_form_button').click

      expect(page).to have_content('Invitee email can\'t be blank')
      expect(page).to have_content('Invitee name can\'t be blank')
    end

    it "should not allow a duplicate invitation to be submitted" do
      existing_user = create(:invitation, invitee_email: 'user.one@example.com', invitee_name: 'User One', code_of_conduct: true)
      sign_in user
      visit new_invitation_path
      expect(page).to have_content('Apply to join')
      expect(page).to have_content('Send invitation to someone else')

      click_on('Send invitation to someone else')
      
      fill_in('Email', with: 'user.one@example.com')
      fill_in('Full Name', with: 'User One')
      find('textarea.introduction-external').set('You will face many defeats in life, but never let yourself be defeated.')
      all('input#invitation_code_of_conduct').last.check
      find('input#slack_invitation_form_button').click

      expect(page).to have_content('Invitee email already exists')
    end
  end
end
