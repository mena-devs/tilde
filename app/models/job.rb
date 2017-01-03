# == Schema Information
#
# Table name: jobs
#
#  apply_email       :string
#  approved          :boolean          default(FALSE)
#  company_name      :string
#  created_at        :datetime         not null
#  custom_identifier :string
#  description       :text
#  expires_on        :datetime
#  id                :integer          not null, primary key
#  job_location      :string
#  job_type          :integer          default("internship")
#  level             :integer          default("no_experience")
#  paid              :boolean
#  posted_on         :datetime
#  posted_to_slack   :boolean          default(FALSE)
#  state             :integer          default("pending")
#  title             :string
#  updated_at        :datetime         not null
#  user_id           :integer
#
# Indexes
#
#  index_jobs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_df6238c8a6  (user_id => users.id)
#

class Job < ApplicationRecord
  extend FriendlyId

  belongs_to :user

  validates :company_name, presence: true
  validates :title, presence: true
  validates :job_location, presence: true

  before_validation :generate_unique_id, on: :create
  before_create :set_dates

  enum job_type: [ :internship, :part_time, :full_time, :contract, :freelance ]
  enum level: [ :no_experience, :beginner, :experienced, :manager ]
  enum state: [ :pending, :posted, :archived ]

  default_scope { where(state: :posted, approved: true) }

  friendly_id :custom_identifier

  private
    def set_dates
      self.posted_on = Time.now.utc
      self.expires_on = Time.now.utc + 1.month
      self.state = :posted
      self.approved = true
    end

    def generate_unique_id
      self.custom_identifier = Digest::SHA1.hexdigest(Time.now.to_s + rand(12341234).to_s + "#{self.title}")[1..24]
    end
end
