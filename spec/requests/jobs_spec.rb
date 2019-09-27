require 'rails_helper'

RSpec.describe "Jobs", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:user_without_profile) { create(:user) }

  describe "GET /jobs" do
    before(:each) do
      @job = create(:job, user: user)
      @unpublished_job = create(:job, user: user, aasm_state: 'draft')
    end

    it "should list all published jobs" do
      get jobs_path
      expect(response).to have_http_status(200)
      expect(response.body).to include(@job.title)
      expect(response.body).to_not include(@unpublished_job.title)
    end
  end

  describe "GET /jobs/new" do
    before do
      @profile = create(:profile, user: user)
    end

    it "should render new job template" do
      sign_in user
      get new_job_path
      expect(response).to have_http_status(200)
      expect(response).to render_template('jobs/new')
    end

    it "should redirect the login user to complete profile editing" do
      sign_in user_without_profile
      get new_job_path
      expect(response).to have_http_status(302)
      expect(response.header['location']).to include('/profile/edit')
    end
  end
end
