# == Schema Information
#
# Table name: profiles
#
#  id                           :integer          not null, primary key
#  user_id                      :integer
#  nickname                     :string
#  location                     :string
#  receive_emails               :boolean          default(FALSE)
#  receive_job_alerts           :boolean          default(FALSE)
#  biography                    :text
#  avatar_from_slack            :string
#  privacy_level                :integer          default(0)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  avatar_file_name             :string
#  avatar_content_type          :string
#  avatar_file_size             :integer
#  avatar_updated_at            :datetime
#  avatar_from_slack_imported   :boolean          default(FALSE)
#  avatar_from_slack_updated_at :datetime
#  title                        :string
#  interests                    :string
#  company_name                 :string
#  twitter_handle               :string
#

require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
