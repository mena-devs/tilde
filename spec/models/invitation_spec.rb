# == Schema Information
#
# Table name: invitations
#
#  id                   :bigint           not null, primary key
#  user_id              :integer
#  invitee_name         :string
#  invitee_email        :string
#  invitee_title        :string
#  invitee_company      :string
#  invitee_location     :string
#  invitee_introduction :text
#  delivered            :boolean          default(FALSE)
#  registered           :boolean          default(FALSE)
#  code_of_conduct      :boolean          default(FALSE)
#  member_application   :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  slack_uid            :string
#  medium               :string
#  aasm_state           :string
#  retries              :integer          default(0)
#

require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe "ActiveRecord associations" do
    # Associations
    it { is_expected.to belong_to(:user) }
  end

  describe "Validations" do
    let(:invitation) { create(:invitation, code_of_conduct: true) }

    it "valid object" do
      expect(invitation).to be_valid
    end

    it "should accept the Code of Conduct" do
      expect { create(:invitation) }.to raise_error(ActiveRecord::RecordInvalid, /Please accept our Code of Conduct to proceed/)
    end

    it { should validate_presence_of :invitee_email }
    it { should validate_uniqueness_of :invitee_email }
    it { should validate_presence_of :invitee_name }
    
    describe '#email' do
      it { should_not allow_value("blah").for(:invitee_email) }
      it { should allow_value("a@b.com").for(:invitee_email) }
    end
  end

  describe "location" do
    let(:invitation) { create(:invitation, code_of_conduct: true) }

    it "should return an empty string if invalid country" do
      invitation.update(invitee_location: '')
      expect(invitation.location_name).to eq('Not set')
    end

    it "should return country code" do
      expect(invitation.location_name).to eq('France')
      
      invitation.update(invitee_location: 'LB')
      expect(invitation.location_name).to eq('Lebanon')
    end
  end

  describe "State transitions" do
    let(:invitation) { create(:invitation, code_of_conduct: true) }
    let(:sent_invitation) { create(:invitation, code_of_conduct: true, aasm_state: :sent) }

    before do
      ActiveJob::Base.queue_adapter = :test
    end

    it 'has default state' do
      expect(invitation.aasm_state).to eq('not_sent')
    end

    it 'should transition to sent' do
      allow(invitation).to receive(:process_invitation).and_return(true)

      expect(invitation.send_invite!).to be(true)
      expect(invitation.aasm_state).to eq('sent')
    end

    it 'should transition to resent if resent' do
      allow(sent_invitation).to receive(:resend_invitation).and_return(true)

      expect(sent_invitation.resend_invite!).to be(true)
      expect(sent_invitation.aasm_state).to eq('resent')
    end
  end

  describe "#process_invitation" do
    it "should send email on creation of invitation" do
      expect {
        create(:invitation, code_of_conduct: true)
      }.to change {
        ActiveJob::Base.queue_adapter.enqueued_jobs.count
      }.by (1)
    end
  end

  describe "#resend_invitation" do
    let(:invitation) { create(:invitation, code_of_conduct: true) }

    it "should send email on resending an invitation" do
      allow(invitation).to receive(:process_invitation_on_slack).and_return(true)

      expect {
        expect(invitation.resend_invitation).to be(true)
      }.to change {
        ActiveJob::Base.queue_adapter.enqueued_jobs.count
      }.by (1)
    end

    it "should increment counter on invitation" do
      allow(invitation).to receive(:process_invitation_on_slack).and_return(true)

      expect {
        expect(invitation.resend_invitation).to be(true)
      }.to change {
        invitation.retries
      }.by (1)
    end
  end
end
