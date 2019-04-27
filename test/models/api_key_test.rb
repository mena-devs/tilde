# == Schema Information
#
# Table name: api_keys
#
#  id           :integer          not null, primary key
#  access_token :string
#  user_id      :integer
#  enabled      :boolean          default(TRUE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class ApiKeyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
