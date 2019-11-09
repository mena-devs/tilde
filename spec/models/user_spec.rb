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
end