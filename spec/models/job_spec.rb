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

    # context "from_salary is set" do
    #   before do
    #     job.from_salary = 1000
    #     job.to_salary = 1100
    #     job.save
    #   end

    #   it { should validate_presence_of :currency }
    #   it { should validate_presence_of :payment_term }
    # end

    # context "from_salary is not set" do
    #   before { job.from_salary = nil }

    #   it { should_not validate_presence_of :currency }
    #   it { should_not validate_presence_of :payment_term }
    # end
  end

  describe "State transitions" do
    let(:draft_job) { create(:job) }
    let(:approved_job) { create(:job, aasm_state: :under_review) }

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
      allow(NotifierWorker).to receive(:perform_async).and_return(true)
      allow(approved_job).to receive(:notify_subscribers).and_return(true)
      allow(approved_job).to receive(:set_dates).and_return(true)

      expect {
        expect(approved_job.publish!).to be(true)
      }.to have_enqueued_job.on_queue('mailers')

      expect(approved_job.aasm_state).to eq('approved')
    end

    it 'should modify a job' do
      expect(approved_job.modify!).to be(true)
      expect(approved_job.aasm_state).to eq('edited')
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
end
