require 'rails_helper'

RSpec.describe 'api/invitations', type: :request do
  path '/api/v1/invitations' do

    post 'Invitation' do
      tags 'Invitations'
      description 'Create a new invitation to join Slack Group'
      operationId 'createNewInvitation'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      parameter name: :invitation, in: :body, required: true, 
                schema: { '$ref' => '#/components/schemas/invitation' }

      response 201, 'Creates a new invitation' do        
        let!(:user) { create(:user, uid: '1234') }
        let!(:api_key) { create(:api_key, user: user) }
        let(:Authorization) { 'Bearer ' + api_key.access_token }
        let(:invitation) { { invitee_title: 'Developer',
                             invitee_email: 'email@example.com',
                             invitee_name: 'Blue Person',
                             slack_uid: '1234',
                             invitee_company: 'ABC inc' } }

        run_test!
      end

      response 302, 'Resend an existing invitation' do
        let!(:user) { create(:user, uid: '1234') }
        let!(:existing_invitation) { create(:invitation, invitee_email: 'email@example.com', code_of_conduct: true) }
        let!(:api_key) { create(:api_key, user: user) }
        let(:Authorization) { 'Bearer ' + api_key.access_token }
        let(:invitation) { { invitee_title: 'Developer',
                             invitee_email: 'email@example.com',
                             invitee_name: 'Blue Person',
                             slack_uid: '1234',
                             invitee_company: 'ABC inc' } }
        
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Found existing invitation. Invitation was resent.')
        end
      end

      response 422, 'invalid parameters' do
        let!(:user) { create(:user, uid: '1234') }
        let!(:api_key) { create(:api_key, user: user) }
        let(:Authorization) { 'Bearer ' + api_key.access_token }
        let(:invitation) { { invitee_title: 'Developer',
                             invitee_email: '',
                             invitee_name: '',
                             slack_uid: '1234',
                             invitee_company: 'ABC inc' } }

        schema '$ref' => '#/components/schemas/errors_object'
        
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq({"invitee_email"=>["can't be blank"], "invitee_name"=>["can't be blank"]})
        end
      end

      response 401, 'unauthorized' do
        let(:Authorization) { 'Bearer ' }
        let(:invitation) { { invitee_title: 'Developer' } }

        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end

      response 405, 'invalid input' do
        let!(:user) { create(:user) }
        let!(:api_key) { create(:api_key, user: user) }
        let(:Authorization) { 'Bearer ' + api_key.access_token }
        let(:invitation) { { invitee_title: 'Developer' } }

        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end      
    end

    get 'Invitation' do
      tags 'Invitations'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      response '200', 'Retrieve invitations' do        
        let!(:user) { create(:user) }
        let!(:api_key) { create(:api_key, user: user) }
        let(:Authorization) { 'Bearer ' + api_key.access_token }

        run_test!
      end
    end
  end
end