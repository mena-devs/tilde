# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  provider               :string
#  uid                    :string
#  auth_token             :string
#  first_name             :string
#  last_name              :string
#  time_zone              :string
#  admin                  :boolean          default(FALSE)
#  custom_identifier      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  active                 :boolean          default(TRUE)
#  email_reminders        :string
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe "ActiveRecord associations" do
    # Associations
    it { is_expected.to have_one(:profile) }
    it { is_expected.to have_many(:jobs) }
    it { is_expected.to have_many(:api_keys) }
    it { is_expected.to have_many(:job_statistic) }
  end

  describe "Validations" do
    let(:user) { create(:user) }

    it "valid object" do
      expect(user).to be_valid
    end

    it { should validate_uniqueness_of :email }
    
    describe '#email' do
      it { should_not allow_value("blah").for(:email) }
      it { should allow_value("a@b.com").for(:email) }
    end
  end

  describe "#new_from_slack_oauth" do
    before do
      allow(AppSettings).to receive(:slack_team_id).and_return(1234)
    end

    it "should instantiate a valid user from an incoming hash" do
      info_hash = OmniAuth::AuthHash::InfoHash.new( { uid: 12344, provider: 'slack',
                                                      info: { team_id: AppSettings.slack_team_id,
                                                              email: 'user@example.com',
                                                              first_name: 'user',
                                                              last_name: 'one',
                                                              time_zone: 'Europe/Amsterdam'
                                                            },
                                                      credentials: { token: 'asdasdsdsdads'} } )

      user = User.new
      expect(user.email).to eq('')
      expect(user.first_name).to be(nil)
      expect(user.profile).to be(nil)

      expect(user.new_from_slack_oauth(info_hash)).to be_a_kind_of(User)
      expect(user.email).to eq('user@example.com')
      expect(user.first_name).to eq('user')
      expect(user.active).to be(true)
      expect(user.profile).to be_a_kind_of(Profile)
    end

    it "should instantiate an invalid user from an incoming hash" do
      info_hash = OmniAuth::AuthHash::InfoHash.new( { uid: 12344, provider: 'slack',
                                                      info: { team_id: AppSettings.slack_team_id,
                                                              email: 'userbluemoon',
                                                              first_name: 'user',
                                                              last_name: 'one',
                                                              time_zone: 'Europe/Amsterdam'
                                                            },
                                                      credentials: { token: 'asdasdsdsdads'} } )

      user = User.new
      expect(user.email).to eq('')
      expect(user.first_name).to be_nil
      expect(user.profile).to be_nil

      expect(user.new_from_slack_oauth(info_hash)).to be_a_kind_of(User)
      expect(user).to_not be_valid
      expect(user.profile).to be_nil
    end
  end

  describe "#new_from_slack_token" do
    before do
      slack_user_info = file_fixture("slack_user_info.json").read
      @slack_user_info = JSON.parse(slack_user_info)
    end

    it "should instantiate a valid user from an incoming hash" do
      expect_any_instance_of(Profile).to receive(:download_slack_avatar).and_return(true)
      user = User.new_from_slack_token(@slack_user_info)
      expect(user).to be_a_kind_of(User)
      expect(user.profile).to be_a_kind_of(Profile)
      expect(user.valid?).to be(true)
    end

    it "should instantiate an invalid user from an incoming hash" do
      @slack_user_info['user']['profile']['email'] = 'asdfasdfasd'

      user = User.new_from_slack_token(@slack_user_info)
      expect(user).to be_a_kind_of(User)
      expect(user.profile).to be(nil)
      expect(user.valid?).to be(false)
    end
  end

  describe "#find_user_by_slack_uid" do
    let(:user) { create(:user)}

    before do
      allow(AppSettings).to receive(:slack_team_id).and_return(1234)
    end

    it "should return user object if found" do
      expect(User.find_user_by_slack_uid(user.uid)).to be_a_kind_of(User)
    end

    it "should instantiate a user if Slack ID is not found" do
      info_hash = OmniAuth::AuthHash::InfoHash.new( { uid: 12344, provider: 'slack',
      info: { team_id: AppSettings.slack_team_id,
              email: 'userbluemoon',
              first_name: 'user',
              last_name: 'one',
              time_zone: 'Europe/Amsterdam'
            },
      credentials: { token: 'asdasdsdsdads'} } )

      allow(SlackApi).to receive(:get_user_info).and_return(info_hash)

      expect {
        @user = User.find_user_by_slack_uid(user.uid)
      }.to change {
        User.count
      }.by (1)

      expect(@user.confirmed?).to be(true)
    end
  end

  describe "#from_omniauth" do
    before do
      allow(AppSettings).to receive(:slack_team_id).and_return(1234)
      @info_hash = OmniAuth::AuthHash::InfoHash.new( { uid: 12344, provider: 'slack',
                                                      info: { team_id: AppSettings.slack_team_id,
                                                              email: 'user@example.com',
                                                              first_name: 'user',
                                                              last_name: 'one',
                                                              time_zone: 'Europe/Amsterdam'
                                                            },
                                                      credentials: { token: 'asdasdsdsdads'} } )
    end

    let(:existing_user) { create(:user)}

    it "should create a new user from Slack" do
      expect {
        @user = User.from_omniauth(@info_hash)
      }.to change {
        User.count
      }.by (1)

      expect(@user).to be_a_kind_of(User)
      expect(@user.email).to eq('user@example.com')
      expect(@user.active).to be(true)
    end

    it "should reload existing user from database" do
      @info_hash[:info][:email] = existing_user.email
      expect {
        User.from_omniauth(@info_hash)
      }.to_not change {
        User.count
      }
    end
  end

  describe "#update_user_from_slack" do
    before do
      slack_user_info = file_fixture("slack_user_info.json").read
      @slack_user_info = JSON.parse(slack_user_info)["user"]
    end

    let(:existing_user) { create(:user) }

    it "should create a new user from Slack information" do
      expect_any_instance_of(Profile).to receive(:download_slack_avatar).and_return(true)

      expect(User.update_user_from_slack(@slack_user_info)).to be(true)
    end

    it "should not create a new user" do
      @slack_user_info["profile"]["email"] = existing_user.email

      expect(User.update_user_from_slack(@slack_user_info)).to be(false)
    end
  end

  describe "#name" do
    let(:user_invalid_name) { create(:user, first_name: '', last_name: '') }
    let(:user) { create(:user) }

    it "should return empty if not assigned" do
      expect(user_invalid_name.name).to eql("")
    end

    it "should return empty if not assigned" do
      expect(user.name).not_to be(nil)
    end
  end

  describe "self#to_csv" do
    let(:user_1) { create(:user, email: "user_one@example.com") }
    let(:user_2) { create(:user) }

    it "should return a string" do
      expect([user_1, user_2].to_csv).to be_kind_of(String)
    end

    it "should return objects with name and email as attributes only" do
      expect([user_1, user_2].to_csv).to eq("#{user_1},#{user_2}\n")
    end
  end

  describe "#connected_via_slack?" do
    let(:slack_user) { create(:user, provider: 'slack', uid: '1234') }
    let(:user) { create(:user, provider: 'facebook', uid: '') }

    it "should return true if the user is signed in via Slack" do
      expect(slack_user.connected_via_slack?).to be(true)
    end

    it "should return empty if not assigned" do
      expect(user.connected_via_slack?).to be(false)
    end
  end

  describe "#disconnect_slack" do
    let(:slack_user) { create(:user, provider: 'slack', uid: '1234', auth_token: 'dsafadsfasd') }

    it "should disconnect user from Slack" do
      slack_user.disconnect_slack

      expect(slack_user.provider).to be(nil)
      expect(slack_user.uid).to be(nil)
      expect(slack_user.auth_token).to be(nil)
    end
  end
end
