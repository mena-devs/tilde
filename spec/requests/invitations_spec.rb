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
end
