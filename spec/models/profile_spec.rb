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

  describe "#reload_avatar_from_slack" do
    let(:incomplete_user) { create(:user, uid: "") }
    let(:incomplete_profile) { create(:profile, user: incomplete_user) }
    let(:profile) { create(:profile) }

    it "should clear avatar from Slack fields if user is not Slack member" do
      expect(incomplete_profile.avatar_from_slack).to eq('my_profile_picture.png')
      expect(incomplete_profile.avatar_from_slack_imported).to eq(true)
      
      expect(incomplete_profile.reload_avatar_from_slack).to be(true)

      expect(incomplete_profile.avatar_from_slack).to eq('')
      expect(incomplete_profile.avatar_from_slack_imported).to eq(false)
    end

    it "should import user's avatar from Slack if user is a Slack member" do
      slack_user_info = file_fixture("slack_user_info.json").read
      slack_user_image = file_fixture("slack_profile_picture.png")
      json = JSON.parse(slack_user_info)

      allow(SlackApi).to receive(:get_user_info).and_return(json)
      allow(profile).to receive(:download_slack_avatar).and_return(true)
      expect(profile.reload_avatar_from_slack).to be(true)
    end
  end

  describe "#download_slack_avatar" do
    let(:profile) { create(:profile) }

    it "should import user's avatar from Slack if user is a Slack member" do
      slack_user_image = file_fixture("slack_profile_picture.png")
      allow(URI).to receive(:parse).with(anything()).and_return(slack_user_image)
      expect(profile.download_slack_avatar).to be(true)
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

  describe "#active_interests" do
    let(:profile) { create(:profile) }

    it "should return a list of active interests" do
      expect(profile.active_interests).to eq({"collaborate_on_a_project"=>"1", "to_mentor_someone"=>"1"})
    end

    it "should return a list of all interests" do
      expect(profile.interests).to eq({"a_new_role"=>"0", "collaborate_on_a_project"=>"1", "freelance"=>"0", "to_mentor_someone"=>"1"})
    end
  end
end