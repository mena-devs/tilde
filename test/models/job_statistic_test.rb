# == Schema Information
#
# Table name: job_statistics
#
#  id         :bigint           not null, primary key
#  job_id     :integer
#  user_id    :integer
#  counter    :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class JobStatisticTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
