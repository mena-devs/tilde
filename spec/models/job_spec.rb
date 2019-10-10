require 'rails_helper'

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

    it "valid object" do
      job = build(:job)
      expect(job).to be_valid
    end

    it "generate custom_identifier" do
      job = create(:job)
      expect(job.custom_identifier).to_not be_empty
    end

    it "validate from salary to be less than to salary range" do
      job = create(:job)
      job.from_salary = 1500
      job.to_salary = 500
      expect(job).to_not be_valid
      expect(job.errors[:to_salary]).to eq(['cannot be less than starting salary'])

      job.from_salary = 10
      job.to_salary = 10
      expect(job).to_not be_valid
      expect(job.errors[:to_salary]).to eq(['cannot be less than starting salary'])
    end
  end
end
