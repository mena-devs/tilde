require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe SlackApi do
  describe "#get_user_info" do
    before do
      slack_user_info = file_fixture("slack_user_info.json").read
      invalid_slack_user_info = file_fixture("invalid_slack_user_info.json").read
      @valid_user_info = JSON.parse(slack_user_info)
      @invalid_user_info = JSON.parse(invalid_slack_user_info)
    end

    it "should return user object from Slack user info API" do
      allow(SlackApi).to receive(:get_user_info).and_return(@valid_user_info)
      get_user_info = SlackApi.get_user_info(1234)
      
      expect(get_user_info).to eq(@valid_user_info)
      expect(get_user_info["ok"]).to eq(true)
      expect(get_user_info["user"]["real_name"]).to eq("Egon Spengler")
    end

    it "should return an error if user is not found from Slack user info API" do
      allow(SlackApi).to receive(:get_user_info).and_return(@invalid_user_info)
      get_user_info = SlackApi.get_user_info(1234)
      
      expect(get_user_info).to eq(@invalid_user_info)
      expect(get_user_info["ok"]).to eq(false)
      expect(get_user_info["error"]).to eq("user_not_found")
    end
  end

  describe "#send_invitation" do
    before do
      slack_user_invite = file_fixture("slack_users_admin_invite.json").read
      invalid_slack_user_invite = file_fixture("invalid_slack_users_admin_invite.json").read
      @valid_user_invite = JSON.parse(slack_user_invite)
      @invalid_user_invite = JSON.parse(invalid_slack_user_invite)
    end

    it "should return OK from Slack invitation API" do
      allow(SlackApi).to receive(:send_invitation).and_return(@valid_user_invite)
      user_invitation = SlackApi.send_invitation('email@example.com')
      
      expect(user_invitation).to eq(@valid_user_invite)
      expect(user_invitation["ok"]).to eq(true)
    end

    it "should return an error on invitation from Slack invitation API" do
      allow(SlackApi).to receive(:send_invitation).and_return(@invalid_user_invite)
      user_invitation = SlackApi.send_invitation('blabla bla')
      
      expect(user_invitation).to eq(@invalid_user_invite)
      expect(user_invitation["ok"]).to eq(false)
      expect(user_invitation["error"]).to eq("invalid_email")
    end
  end

  describe "#all_users" do
    before do
      slack_all_users_info = file_fixture("slack_users_list.json").read
      invalid_slack_all_users_info = file_fixture("slack_users_list_error.json").read
      @valid_slack_all_users_info = JSON.parse(slack_all_users_info)
      @invalid_slack_all_users_info = JSON.parse(invalid_slack_all_users_info)
    end

    it "should return OK from Slack users API" do
      allow(SlackApi).to receive(:all_users).and_return(@valid_slack_all_users_info)
      all_users = SlackApi.all_users
      
      expect(all_users).to eq(@valid_slack_all_users_info)
      expect(all_users["ok"]).to eq(true)
    end

    it "should return an error when requesting all users info from Slack users API" do
      allow(SlackApi).to receive(:all_users).and_return(@invalid_slack_all_users_info)
      all_users = SlackApi.all_users
      
      expect(all_users).to eq(@invalid_slack_all_users_info)
      expect(all_users["ok"]).to eq(false)
      expect(all_users["error"]).to eq("invalid_cursor")
    end
  end
end
