require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe "ActiveRecord associations" do
    # Associations
    it { is_expected.to belong_to(:user) }
  end

  describe "Validations" do
    it "valid object" do
      invitation = build(:invitation)
      expect(invitation).to be_valid
    end
  end
end
