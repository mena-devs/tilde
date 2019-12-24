require 'rails_helper'

RSpec.describe "Jobs", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let(:user_without_profile) { create(:user) }
  let(:member) { create(:user) }

  describe "GET /jobs" do
    before(:each) do
      @job = create(:job, user: user, aasm_state: 'approved')
      @unpublished_job = create(:job, user: user)
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

    it "should validate required fields" do
      sign_in user
      visit new_job_path

      fill_in 'Job title', with: 'Test Title'
      fill_in 'URL to apply to job',  with: 'https://example.com/jobs/1'
      fill_in 'Description',  with: 'Lorem ipsum'

      click_on 'Save and continue'
      expect(page).to have_content('Please review the problems below')
      expect(page).to have_content('Company name can\'t be blank')
      expect(page).to have_content('Employment type can\'t be blank')
      expect(page).to have_content('Experience can\'t be blank')
      expect(page).to have_content('From salary can\'t be blank')
    end

    it "should save job if all required fields are filled" do
      sign_in user
      visit new_job_path

      fill_in 'Job title', with: 'Test Title'
      fill_in 'URL to apply to job',  with: 'https://example.com/jobs/1'
      fill_in 'Description',  with: 'Lorem ipsum'
      fill_in 'Company name',  with: 'Company name'
      select('Part time', :from => 'Employment type')
      select('Associate', :from => 'Experience')
      fill_in 'Starting salary',  with: '1000'
      select('Per month', :from => 'Payment term')
      select('United States Dollar (USD)', :from => 'Currency')

      click_on 'Save and continue'
      
      expect(page).to have_content('Job post was successfully created.')

      expect(page).to have_content('Test Title')
      
      expect(page).to have_content('By: ' + user.name)
    
      expect(page).to have_content('Submit for approval')
      expect(page).to have_content('Edit')
    end
  end

  describe "GET /jobs/show" do
    before do
      @profile = create(:profile, user: user)
      @job = create(:job, user: user, aasm_state: 'draft')
    end
    
    it "should allow submitting a draft job for approval" do
      sign_in user
      visit(job_path(@job))

      expect(page).to have_content(@job.title)

      click_on 'Submit for approval'
      
      expect(page).to have_content('Job post was successfully submitted for approval before made public.')
      expect(page).to have_content('By: ' + user.name)
      expect(page).to have_content('Statistics')
    end
  end

  describe "GET /jobs/show" do
    before do
      @job = create(:job, user: user, aasm_state: 'approved')
    end
    
    it "should allow anonymous viewing of a job" do
      visit(job_path(@job))

      expect(page).to have_content(@job.title)
      expect(page).to have_content('Tell a friend')
      expect(page).to_not have_content('Statistics')
    end

    it "should log statistics for logged in members" do
      assert @job.job_statistics.count, 0
      sign_in member
      visit(job_path(@job))
      
      expect(page).to have_content(@job.title)
      expect(page).to_not have_content('Statistics')
      assert @job.job_statistics.count, 1
    end

    it "should show job statistics to Job Owner" do
      sign_in user
      visit(job_path(@job))
      
      expect(page).to have_content(@job.title)
      expect(page).to have_content('Statistics')
      expect(page).to have_content(member.name)
    end

    it "should show job statistics to ADMINS" do
      sign_in admin
      visit(job_path(@job))
      
      expect(page).to have_content(@job.title)
      expect(page).to have_content('Statistics')
      expect(page).to have_content(member.name)
    end
  end

  describe "POST /jobs/:id/approve" do
    before do
      @pending_job = create(:job, user: user, aasm_state: 'under_review')
      @profile = create(:profile, user: admin)
    end
    
    it "should allow admin to approve pending job" do
      sign_in admin
      visit(job_path(@pending_job))
      
      # Stub notifier method
      allow(NotifierWorker).to receive(:perform_async).and_return(true)
      
      expect(page).to have_content(@pending_job.title)
      # not approved yet
      expect(page).to_not have_content('Tell a friend')
      
      click_on('Approve (as admin)', match: :first)

      expect(page).to have_content('The job is now live.')
      expect(page).to have_button('Take down (as admin)')
      expect(page).to have_content('Tell a friend')
      expect(page).to have_content('Statistics')
    end
  end
end