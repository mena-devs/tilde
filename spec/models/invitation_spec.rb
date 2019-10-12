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

    it "should default to Lebanon if not set" do
      invitation.update(invitee_location: '')
      expect(invitation.invitee_location_name).to eq('Lebanon')
    end

    it "should return country code" do
      expect(invitation.invitee_location_name).to eq('Lebanon')
      
      invitation.update(invitee_location: 'FR')
      expect(invitation.invitee_location_name).to eq('France')
    end
  end
end