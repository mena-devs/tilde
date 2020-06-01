require 'swagger_helper'

RSpec.describe 'api/jobs', type: :request do
  path '/api/v1/jobs' do

    get 'All jobs' do
      tags 'Jobs'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      parameter name: 'page[number]', in: :query, required: false, description: 'Allow navigation through a large set of objects', schema: { type: :integer, format: :int32 }

      response '200', 'Return published and approved jobs' do
        schema '$ref' => '#/components/schemas/jobs'
        
        let!(:user) { create(:user) }
        let!(:api_key) { create(:api_key, user: user) }
        let!(:job_1) { create(:job, user: user, aasm_state: 'approved' ) }
        let!(:job_2) { create(:job, user: user, aasm_state: 'approved' ) }
        let(:Authorization) { 'Bearer ' + api_key.access_token }

        run_test! do |response|
          data = JSON.parse(response.body)
          ids = data['data'].map {|obj| obj['id'] }
          expect(ids).to include(job_1.custom_identifier)
        end
      end

      response 401, 'unauthorized' do
        let(:Authorization) { 'Bearer ' }

        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/jobs/{id}' do

    get 'Retrieves a job' do
      tags 'Job'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      parameter name: :id, in: :path, description: 'ID of a job that you wish to retrieve', type: :string

      response '200', 'job found' do
        schema schema '$ref' => '#/components/schemas/jobs'

        let!(:user) { create(:user) }
        let!(:api_key) { create(:api_key, user: user) }
        let!(:job) { create(:job, user: user, aasm_state: 'approved' ) }
        let!(:id) { job.custom_identifier }
        let(:Authorization) { 'Bearer ' + api_key.access_token }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data'].first['id']).to eq(job.custom_identifier)
        end
      end
    end
  end
end