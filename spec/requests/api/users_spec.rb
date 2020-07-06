require 'swagger_helper'

RSpec.describe 'api/users', type: :request do
  path '/api/v1/users' do

    get 'All users' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      parameter name: 'page[number]', in: :query, required: false, description: 'Allow navigation through a large set of objects', schema: { type: :integer, format: :int32 }

      response '200', 'Return verified users' do
        schema '$ref' => '#/components/schemas/users'
        
        let!(:user) { create(:user) }
        let!(:api_key) { create(:api_key, user: user) }
        let!(:user_1) { create(:user) }
        let!(:user_2) { create(:user) }
        let(:Authorization) { 'Bearer ' + api_key.access_token }

        run_test! do |response|
          data = JSON.parse(response.body)
          ids = data['data'].map {|obj| obj['id'] }
          expect(ids).to include(user_1.custom_identifier)
        end
      end

      response 401, 'unauthorized' do
        let(:Authorization) { 'Bearer ' }

        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do

    get 'Retrieves a user' do
      tags 'User'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      parameter name: :id, in: :path, description: 'ID of a user that you wish to retrieve', type: :string

      response '200', 'user found' do
        schema schema '$ref' => '#/components/schemas/user'

        let!(:user) { create(:user) }
        let!(:member) { create(:user) }
        let!(:api_key) { create(:api_key, user: user) }
        let!(:id) { member.custom_identifier }
        let(:Authorization) { 'Bearer ' + api_key.access_token }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data']['id']).to eq(member.custom_identifier)
        end
      end

      response '404', 'user not found' do

        let!(:user) { create(:user) }
        let!(:api_key) { create(:api_key, user: user) }
        let!(:id) { '1234' }
        let(:Authorization) { 'Bearer ' + api_key.access_token }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq("Record not found")
        end
      end
    end
  end

  path '/api/v1/users/search' do

    get 'Searches for a user by first_name' do
      tags 'User'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      parameter name: "query[first_name]", in: :query, description: 'search query', type: :string

      response '200', 'user found by first_name' do
        schema schema '$ref' => '#/components/schemas/users'

        let!(:user) { create(:user) }
        let!(:member) { create(:user) }
        let!(:api_key) { create(:api_key, user: user) }
        let!("query[first_name]") { member.first_name }
        let(:Authorization) { 'Bearer ' + api_key.access_token }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data'].first['id']).to eq(member.custom_identifier)
          expect(data['data'].first['type']).to eq("user")
          expect(data['data'].first['attributes']['first_name']).to eq(member.first_name)
        end
      end

      response '404', 'User not found' do

        let!(:user) { create(:user) }
        let!(:api_key) { create(:api_key, user: user) }
        let!("query[first_name]") { '1234' }
        let(:Authorization) { 'Bearer ' + api_key.access_token }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq("Record not found")
        end
      end
    end

    get 'Searches for a user by last_name' do
      tags 'User'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      parameter name: "query[last_name]", in: :query, description: 'search query', type: :string

      response '200', 'user found by last_name' do
        schema schema '$ref' => '#/components/schemas/users'

        let!(:user) { create(:user) }
        let!(:member) { create(:user, last_name: 'bluezone') }
        let!(:api_key) { create(:api_key, user: user) }
        let!("query[last_name]") { member.last_name }
        let(:Authorization) { 'Bearer ' + api_key.access_token }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data'].first['id']).to eq(member.custom_identifier)
          expect(data['data'].first['type']).to eq('user')
          expect(data['data'].first['attributes']['last_name']).to eq(member.last_name)
        end
      end
    end

    get 'Searches for a user by first_name, last_name, email or title'  do
      tags 'User'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      parameter name: "query[email]", in: :query, description: 'search query', type: :string

      response '200', 'user found by first_name, last_name, email or title' do
        schema schema '$ref' => '#/components/schemas/users'

        let!(:user) { create(:user) }
        let!(:member) { create(:user) }
        let!(:api_key) { create(:api_key, user: user) }
        let!("query[email]") { member.email }
        let(:Authorization) { 'Bearer ' + api_key.access_token }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data'].first['id']).to eq(member.custom_identifier)
          expect(data['data'].first['type']).to eq('user')
          expect(data['data'].first['attributes']['email']).to eq(member.email)
        end
      end
    end

    get 'Searches for a user using an incorrect query name' do
      tags 'User'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      parameter name: "something", in: :query, description: 'search query', type: :string

      response '422', 'Invalid request' do

        let!(:user) { create(:user) }
        let!(:api_key) { create(:api_key, user: user) }
        let!("something") { '1234' }
        let(:Authorization) { 'Bearer ' + api_key.access_token }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq("Invalid request")
        end
      end
    end

    get 'Searches for a user using an incorrect query parameter' do
      tags 'User'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      parameter name: "query", in: :query, description: 'search query', type: :string

      response '422', 'Invalid request' do

        let!(:user) { create(:user) }
        let!(:api_key) { create(:api_key, user: user) }
        let!("query") { '1234' }
        let(:Authorization) { 'Bearer ' + api_key.access_token }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq("Invalid request")
        end
      end
    end
  end
end