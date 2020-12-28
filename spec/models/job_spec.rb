# == Schema Information
#
# Table name: jobs
#
#  id                 :integer          not null, primary key
#  aasm_state         :string
#  title              :string
#  description        :text
#  external_link      :string
#  country            :string
#  remote             :boolean          default(FALSE)
#  custom_identifier  :string
#  posted_on          :datetime
#  expires_on         :datetime
#  posted_to_slack    :boolean          default(FALSE)
#  user_id            :integer
#  company_name       :string
#  apply_email        :string
#  to_salary          :integer
#  employment_type    :integer
#  number_of_openings :integer          default(1)
#  experience         :integer
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  from_salary        :integer
#  currency           :string
#  education          :string
#  payment_term       :integer
#  twitter_handle     :string
#  slug               :string
#  hired              :boolean          default(FALSE)
#  equity             :boolean
#

require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe Job, type: :model do
  describe "ActiveRecord associations" do
    # Associations
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:job_statistics) }
  end

  describe "Validations" do
    describe '#email' do
      it { should_not allow_value("blah").for(:apply_email) }
      it { should allow_value("a@b.com").for(:apply_email) }
    end

    let(:job) { create(:job) }

    it "valid object" do
      expect(job).to be_valid
    end

    it "generate custom_identifier" do
      expect(job.custom_identifier).to_not be_empty
    end

    it "validate from salary to be less than to salary range" do
      job.from_salary = 1500
      job.to_salary = 500
      expect(job).to_not be_valid
      expect(job.errors[:to_salary]).to eq(['cannot be less than starting salary'])

      job.from_salary = 10
      job.to_salary = 10
      expect(job).to_not be_valid
      expect(job.errors[:to_salary]).to eq(['cannot be less than starting salary'])
    end

    it { should validate_presence_of :company_name }
    it { should validate_presence_of :title }
    it { should validate_presence_of :employment_type }
    it { should validate_presence_of :experience }
  end

  describe "State transitions" do
    let(:draft_job) { create(:job) }
    let(:under_review_job) { create(:job, aasm_state: :under_review) }
    let(:approved_job) { create(:job, aasm_state: :approved) }

    before do
      ActiveJob::Base.queue_adapter = :test
    end

    it 'has default state' do
      expect(draft_job.aasm_state).to eq('draft')
    end

    it 'should request approval' do
      expect {
        expect(draft_job.request_approval!).to be(true)
      }.to have_enqueued_job.on_queue('mailers')

      expect(draft_job.aasm_state).to eq('under_review')
    end

    it 'should publish live' do
      allow(SlackNotifierWorker).to receive(:perform_async).and_return(true)
      allow(BufferNotifierWorker).to receive(:perform_async).and_return(true)
      allow(under_review_job).to receive(:set_dates).and_return(true)

      expect {
        expect(under_review_job.publish!).to be(true)
      }.to have_enqueued_job.on_queue('mailers')

      expect(under_review_job.aasm_state).to eq('approved')
    end

    it 'should modify a job' do
      expect(under_review_job.modify!).to be(true)
      expect(under_review_job.aasm_state).to eq('edited')
    end

    it 'should unpublish a job' do
      expect {
        expect(approved_job.take_down!).to be(true)
      }.to have_enqueued_job.on_queue('mailers')

      expect(approved_job.aasm_state).to eq('disabled')
    end

    it 'should raise an error on invalid transition' do
      expect { approved_job.request_approval! }.to raise_error(AASM::InvalidTransition, /cannot transition from/)
    end
  end

  describe "#location_name" do
    let(:job) { create(:job, country: 'FR') }

    it "should return a valid country name" do
      expect(job.location_name).to eq('France')
    end

    it "should return an empty string if invalid country" do
      job.update(country: '')
      expect(job.location_name).to eq('Not set')
    end
  end

  describe "Job#remove_expired_jobs" do
    let!(:approved_job_00) { create(:job, aasm_state: :approved, posted_on: (Date.today - 3.months)) }
    let!(:approved_job_01) { create(:job, aasm_state: :approved, posted_on: (Date.today - 45.days)) }
    let!(:approved_job_02) { create(:job, aasm_state: :approved) }

    it "should unpublish live jobs that are older than 1 month" do
      expect(Job.approved.count).to eq(3)

      Job.remove_expired_jobs

      expect(Job.approved.count).to eq(1)
    end
  end

  describe "#text_for_twitter" do
    let(:new_job) { create(:job, aasm_state: :approved, twitter_handle: 'menadevs', title: 'Engineering Manager') }
    let(:twitter_text) { new_job.text_for_twitter }

    it "should include text tag" do
      tweet_text = "text=" + new_job.company_name.titleize

      expect(twitter_text).to match(tweet_text)
    end

    it "should include URL tag" do
      tweet_text = "url=" + new_job.external_link

      expect(twitter_text).to match(/https/)
      expect(twitter_text).to match(new_job.title)
    end

    it "should include Hashtags tag" do
      tweet_text = "hashtags=" + new_job.location_name

      expect(twitter_text).to match(tweet_text)
    end

    it "should include Twitter handle tag" do
      expect(twitter_text).to match(new_job.twitter_handle)
    end
  end
end
