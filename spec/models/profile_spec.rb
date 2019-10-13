require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe "ActiveRecord associations" do
    # Associations
    it { is_expected.to belong_to(:user) }
  end

  describe "Validations" do
    let(:profile) { create(:profile) }

    it "valid object" do
      expect(profile).to be_valid
    end
  end

  describe "#complete" do
    let(:profile) { create(:profile) }
    let(:incomplete_user) { create(:user, first_name: "", last_name: "") }
    let(:invalid_profile) { create(:profile, user: incomplete_user) }

    it "be valid" do
      expect(profile.complete?).to be(true)
    end

    it "be invalid" do
      expect(invalid_profile.complete?).to be(false)
    end
  end

  describe "#profile_picture" do
    let(:empty_avatar_profile) { create(:profile, avatar_from_slack: '') }
    let(:profile) { create(:profile) }

    it "return default profile picture" do
      expect(empty_avatar_profile.profile_picture).to eq('profile_picture_default.png')
    end

    it "return previously set profile picture" do
      expect(profile.profile_picture).to eq('my_profile_picture.png')
    end
  end

  describe "#location_name" do
    let(:profile) { create(:profile) }

    it "should return a valid country name" do
      expect(profile.location_name).to eq('France')
    end

    it "should return an empty string if invalid country" do
      profile.update(location: '')
      expect(profile.location_name).to eq('Not set')
    end
  end
end