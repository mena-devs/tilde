require 'rails_helper'

RSpec.describe "Api::V1::Invitations", type: :request do
  include Devise::Test::IntegrationHelpers

  let!(:user) { create(:user) }
  let(:api_key) { create(:api_key, user: user) }
  let(:invitation) { create(:invitation, user: user, code_of_conduct: true) }

  describe "GET /api/v1/invitations" do
    before(:each) do
      sign_in user
      
      @new_invitation_params = {
        :invitation => {
          :invitee_title => "Architect",
          :invitee_name => "User One",
          :invitee_email => "email@example.com",
          :slack_uid => "ABCDEF",
          :invitee_company => "Bluez Inc"
        }
      }

      @existing_invitation_params = {
        :invitation => {
          :invitee_title => "Architect",
          :invitee_name => "User One",
          :invitee_email => invitation.invitee_email,
          :slack_uid => "ABCDEF",
          :invitee_company => "Bluez Inc"
        }
      }
    end

    it "should render an error if unauthorized" do
      headers = {
        "CONTENT_TYPE" => "application/json",
        "ACCEPT" => "application/json"
      }

      post api_v1_invitations_path, params: @new_invitation_params.to_json, headers: headers

      expect(response).to have_http_status(401)

      incoming_response = JSON.parse(response.body)

      expect(incoming_response["ok"]).to eql(false)
      expect(incoming_response["error"]).to eql("unauthorized")
    end

    it "should create a new invitation" do
      headers = {
        "CONTENT_TYPE" => "application/json",
        "ACCEPT" => "application/json"
      }
      @new_invitation_params["auth_token"] = api_key.access_token
      allow(User).to receive(:find_user_by_slack_uid).and_return(user)

      post api_v1_invitations_path, params: @new_invitation_params.to_json, headers: headers
      expect(response).to have_http_status(201)
      
      incoming_response = JSON.parse(response.body)
      expect(incoming_response["status"]).to eql(201)
      expect(invitation.reload.retries).to eql(0)
    end

    it "should fail to create a new invitation" do
      headers = {
        "CONTENT_TYPE" => "application/json",
        "ACCEPT" => "application/json"
      }
      @new_invitation_params["auth_token"] = api_key.access_token
      allow(User).to receive(:find_user_by_slack_uid).and_return(nil)

      post api_v1_invitations_path, params: @new_invitation_params.to_json, headers: headers
      expect(response).to have_http_status(422)
      
      incoming_response = JSON.parse(response.body)
      expect(incoming_response["message"]).to eql({"user"=>["must exist"]})
    end

    it "should resend an existing invitation instead of creating a new one" do
      headers = {
        "CONTENT_TYPE" => "application/json",
        "ACCEPT" => "application/json"
      }
      @existing_invitation_params["auth_token"] = api_key.access_token
      allow(User).to receive(:find_user_by_slack_uid).and_return(user)
      expect(invitation.retries).to eql(0)

      post api_v1_invitations_path, params: @existing_invitation_params.to_json, headers: headers
      expect(response).to have_http_status(302)
      
      incoming_response = JSON.parse(response.body)
      expect(incoming_response["status"]).to eql(302)
      expect(invitation.reload.retries).to eql(1)
    end
  end
end
