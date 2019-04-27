# == Schema Information
#
# Table name: invitations
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  invitee_name         :string
#  invitee_email        :string
#  invitee_title        :string
#  invitee_company      :string
#  invitee_location     :string
#  invitee_introduction :text
#  delivered            :boolean          default(FALSE)
#  registered           :boolean          default(FALSE)
#  code_of_conduct      :boolean          default(FALSE)
#  member_application   :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  slack_uid            :string
#  medium               :string
#  aasm_state           :string
#  retries              :integer          default(0)
#

require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
