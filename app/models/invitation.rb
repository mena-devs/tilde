# == Schema Information
#
# Table name: invitations
#
#  created_at           :datetime         not null
#  delivered            :boolean          default(FALSE)
#  id                   :integer          not null, primary key
#  invitee_company      :string
#  invitee_email        :string
#  invitee_introduction :text
#  invitee_location     :string
#  invitee_name         :string
#  invitee_title        :string
#  registered           :boolean          default(FALSE)
#  updated_at           :datetime         not null
#  user_id              :integer
#
# Indexes
#
#  index_invitations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_7eae413fe6  (user_id => users.id)
#

class Invitation < ApplicationRecord
  belongs_to :user

  after_create :send_welcome_email

  validates :invitee_email, presence: true
  validates :invitee_name, presence: true

  private
    def send_welcome_email
      InvitationMailer.welcome_email(self)
    end
end
