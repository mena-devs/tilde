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

    it "should return user object from Slack" do
      allow(SlackApi).to receive(:get_user_info).and_return(@valid_user_info)
      get_user_info = SlackApi.get_user_info(1234)
      
      expect(get_user_info).to eq(@valid_user_info)
      expect(get_user_info["ok"]).to eq(true)
      expect(get_user_info["user"]["real_name"]).to eq("Egon Spengler")
    end

    it "should return an error if user is not found from Slack" do
      allow(SlackApi).to receive(:get_user_info).and_return(@invalid_user_info)
      get_user_info = SlackApi.get_user_info(1234)
      
      expect(get_user_info).to eq(@invalid_user_info)
      expect(get_user_info["ok"]).to eq(false)
      expect(get_user_info["error"]).to eq("user_not_found")
    end
  end
end
