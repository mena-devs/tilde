# == Schema Information
#
# Table name: partners
#
#  id                   :bigint           not null, primary key
#  name                 :string
#  description          :string
#  external_link        :string
#  email                :string
#  active               :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#

require 'test_helper'

class PartnerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
