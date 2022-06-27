require 'rails_helper'

RSpec.describe EmailValidator, type: :model do
  describe "Email validations" do
    let(:user) { create(:user) }

    it 'email_valid?' do
      user.email = 'random-email'

      expect(user.valid?).to be_falsey
    end

    it 'handle_contains_number_of_dots' do
      user.email = 'x.d.va.as.z@gmail.com'

      expect(user.valid?).to be_falsey
    end

    it 'handle_last_character_is_not_dot' do
      user.email = 'x.blue-as.@gmail.com'

      expect(user.valid?).to be_falsey
    end
  end
end
