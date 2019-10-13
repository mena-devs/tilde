# == Schema Information
#
# Table name: invitations
#
#  id                   :bigint           not null, primary key
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

class CodeOfConductValidator < ActiveModel::Validator
  def validate(record)
    if record.code_of_conduct == false
      record.errors[:base] << "Please accept our Code of Conduct to proceed"
    end
  end
end

class Invitation < ApplicationRecord
  include AASM

  aasm do
    state :not_sent, :initial => true
    state :sent
    state :resent
    state :accepted
    state :revoked

    event :send_invite do
      transitions :from => [:not_sent], :to => :sent
      success do
        process_invitation
      end
    end

    event :resend_invite do
      transitions :from => [:not_sent, :sent, :resent], :to => :resent
      success do
        resend_invitation
      end
    end
  end

  after_create :new_invite_notify_administrators

  belongs_to :user

  validates :invitee_email, presence: true, unless: Proc.new { |member| member.invitee_is_member? }
  validates :invitee_email, uniqueness: true, unless: Proc.new { |member| member.invitee_is_member? }
  validates :invitee_name, presence: true, unless: Proc.new { |member| member.invitee_is_member? }
  validates :invitee_email, email: true

  validates_with CodeOfConductValidator

  scope :all_sent, ->(user_id) { where("user_id = ?", user_id) }

  def self.has_pending_invitation_to_join_slack(email)
    where(invitee_email: email).exists?
  end

  def invitee_is_member?
    member_application == true
  end

  def process_invitation
    process_invitation_on_slack
  end

  def resend_invitation
    increment!(:retries)
    resend_invite_notify_administrators
    process_invitation_on_slack
  end

  def location_name
    country_name = "Not set"

    unless invitee_location.blank?
      country = ISO3166::Country[invitee_location]
      country_name = (country.translations[I18n.locale.to_s] || country.name) if country
    end

    country_name
  end

  private
    def new_invite_notify_administrators
      InvitationMailer.new_slack_invitation(self.id).deliver_later
    end

    def resend_invite_notify_administrators
      InvitationMailer.resend_slack_invitation(self.id).deliver_later
    end

    def process_invitation_on_slack
      unless self.invitee_email.blank?
        begin
          response = SlackApi.send_invitation(self.invitee_email)
          return response
        rescue Exception => e
          logger.error(e)
        end
      end
    end
end
