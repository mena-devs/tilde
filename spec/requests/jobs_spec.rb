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
      jobs = []
      (1..11).each do
        jobs.append(create(:job, user: user, aasm_state: 'approved'))
      end

      get jobs_path
      expect(response).to have_http_status(200)
      expect(response.body).to include(@job.title)
      expect(response.body).to_not include(@unpublished_job.title)
      expect(response.body).to include(jobs[2].title)
      expect(response.body).to include(jobs[9].title)
    end

    describe "Signed in user" do
      before do
        @draft_job_1 = create(:job, user: user)
        @draft_job_2 = create(:job, user: user, aasm_state: 'under_review')
        @expired_job = create(:job, user: user, aasm_state: 'disabled')
      end

      it "should allow user to view all their jobs" do
        sign_in(user)
        visit(jobs_path(state: 'user'))

        expect(page).to have_content(@job.title)
        expect(page).to have_content(@draft_job_1.title)
        expect(page).to have_content(@draft_job_2.title)
        expect(page).to have_content(@expired_job.title)
      end

      it "should allow user to view job posts they are drafting" do
        sign_in(user)
        visit(jobs_path(state: 'draft'))

        expect(page).to_not have_content(@job.title)
        expect(page).to have_content(@draft_job_1.title)
        expect(page).to have_content(@draft_job_2.title)
        expect(page).to_not have_content(@expired_job.title)
      end

      it "should allow user to view expired job posts" do
        sign_in(user)
        visit(jobs_path(state: 'expired'))

        expect(page).to_not have_content(@job.title)
        expect(page).to_not have_content(@draft_job_1.title)
        expect(page).to_not have_content(@draft_job_2.title)
        expect(page).to have_content(@expired_job.title)
      end
    end
  end

  describe "GET /jobs/new" do
    before do
      @profile = create(:profile, user: user)
    end

    it "should render new job template" do
      sign_in(user)
      get(new_job_path)
      expect(response).to have_http_status(200)
      expect(response).to render_template('jobs/new')
    end

    it "should redirect the login user to complete profile editing" do
      sign_in(user_without_profile)
      get(new_job_path)
      expect(response).to have_http_status(302)
      expect(response.header['location']).to include('/profile/edit')
    end

    it "should validate required fields" do
      sign_in(user)
      visit(new_job_path)

      fill_in 'Job title', with: 'Test Title'
      fill_in 'URL to apply to job',  with: 'https://example.com/jobs/1'
      fill_in 'Description',  with: 'Lorem ipsum'

      click_on 'Save and continue'
      expect(page).to have_content('Please review the problems below:')
      expect(page).to have_content('Company name can\'t be blank')
      expect(page).to have_content('Employment type can\'t be blank')
      expect(page).to have_content('Experience can\'t be blank')
      expect(page).to have_content('From salary can\'t be blank')
    end

    it "should save job if all required fields are filled" do
      sign_in(user)
      visit(new_job_path)

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
      
      expect(page).to have_content('By ' + user.name)
    
      expect(page).to have_content('Submit for approval')
      expect(page).to have_content('Edit')
      expect(page).to have_content('Delete')
    end
  end

  describe "GET /jobs/show" do
    before do
      @job = create(:job, user: user, aasm_state: 'approved')
    end
    
    it "should allow anonymous viewing of a job" do
      visit(job_path(@job))

      expect(page).to have_content(@job.title)
      expect(page).to have_content('Share this job:')
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

  describe "DELETE /jobs/1" do
    before do
      @job = create(:job, user: user, aasm_state: 'draft')
      user.profile.update(location: 'LB')
    end

    it "should not allow admin to delete a job" do
      sign_in admin
      visit(job_path(@job))
      
      expect(page).to have_content(@job.title)

      expect(page).to_not have_content('Delete')
    end

    it "should allow job owner to delete their job" do
      sign_in user
      visit(job_path(@job))
      
      expect(page).to have_content(@job.title)
      expect(page).to have_content('Delete')

      click_on('Delete', match: :first)

      expect(page).to have_content('Job Board')
      expect(page).to have_content('Job post was successfully deleted.')
    end

    it "should allow job owner to delete job from listing" do
      sign_in user
      visit(jobs_path(state: 'user'))

      expect(page).to have_content(@job.title)
      expect(page).to have_content('Edit')
      expect(page).to have_content('Delete')
    end
  end

  describe "PUT /jobs/:id/pre_approve" do
    before do
      @draft_job = create(:job, user: user, aasm_state: 'draft')
      @profile = create(:profile, user: user)

      allow(SlackNotifierWorker).to receive(:perform_async).and_return(true)
      allow(BufferNotifierWorker).to receive(:perform_async).and_return(true)
    end
    
    it "should allow user to submit job for approval" do
      sign_in user
      visit(job_path(@draft_job))
      
      expect(page).to have_content(@draft_job.title)
      expect(page).to_not have_content('Share this job')
      expect(page).to have_content('Edit')

      click_on('Submit for approval', match: :first)
      expect(page).to have_content('Pending Approval')
      expect(page).to have_content('The job post was successfully submitted for approval before made public.')
      expect(page).to_not have_content('Share this job')
    end
  end

  describe "PUT /jobs/:id/approve" do
    before do
      @pending_job = create(:job, user: user, aasm_state: 'under_review')
      @profile = create(:profile, user: admin)

      allow(SlackNotifierWorker).to receive(:perform_async).and_return(true)
      allow(BufferNotifierWorker).to receive(:perform_async).and_return(true)
    end
    
    it "should allow admin to approve pending job" do
      sign_in admin
      visit(job_path(@pending_job))
      
      expect(page).to have_content(@pending_job.title)
      # not approved yet
      expect(page).to_not have_content('Share this job:')
      
      click_on('Approve', match: :first)

      expect(page).to have_content('The job is now live.')
      expect(page).to have_content('Take down')
      expect(page).to have_content('Share this job:')
      expect(page).to have_content('Statistics')
    end

    it "should not allow anyone to approve pending job" do
      sign_in user
      visit(job_path(@pending_job))
      
      expect(page).to have_content(@pending_job.title)
      # not approved yet
      expect(page).to_not have_content('Share this job:')
      expect(page).to have_content('Pending Approval')
      expect(page).to have_content('Edit')

      expect(page).to_not have_content('Approve')
    end
  end

  describe "PUT /jobs/:id/take_down" do
    before do
      @approved_job = create(:job, user: user, aasm_state: 'approved')
      @profile = create(:profile, user: admin)

      allow(SlackNotifierWorker).to receive(:perform_async).and_return(true)
      allow(BufferNotifierWorker).to receive(:perform_async).and_return(true)
    end
    
    it "should allow admin to take approved job offline" do
      sign_in admin
      visit(job_path(@approved_job))

      expect(page).to have_content(@approved_job.title)
      expect(page).to have_content('Share this job:')
      expect(page).to have_content('Statistics')

      click_on('Take down', match: :first)

      expect(page).to have_content('The job is no longer published.')
      expect(page).to_not have_content('Share this job:')
    end
  end

  describe "PUT /jobs/:id/feedback" do
    before do
      @offline_job = create(:job, user: user, aasm_state: 'disabled')
      @profile = create(:profile, user: user)

      allow(SlackNotifierWorker).to receive(:perform_async).and_return(true)
      allow(BufferNotifierWorker).to receive(:perform_async).and_return(true)
    end
    
    it "should allow job owner to leave feedback on the job" do
      sign_in user
      visit(feedback_job_path(@offline_job))

      expect(page).to have_content(@offline_job.title)
      expect(page).to have_content('Was this job closed because the position was filled?')

      choose('Yes')

      click_on('Update', match: :first)

      expect(page).to have_content('Job post was successfully updated.')
    end
  end
end