require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe "ActiveRecord associations" do
    # Associations
    it { is_expected.to belong_to(:user) }
  end
end
