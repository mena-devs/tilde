# == Schema Information
#
# Table name: jobs
#
#  aasm_state         :string
#  apply_email        :string
#  company_name       :string
#  country            :string
#  created_at         :datetime         not null
#  currency           :string
#  custom_identifier  :string
#  deleted_at         :datetime
#  description        :text
#  education          :string
#  employment_type    :integer
#  experience         :integer
#  expires_on         :datetime
#  external_link      :string
#  from_salary        :string
#  id                 :integer          not null, primary key
#  number_of_openings :integer          default(1)
#  posted_on          :datetime
#  posted_to_slack    :boolean          default(FALSE)
#  remote             :boolean          default(FALSE)
#  title              :string
#  to_salary          :string
#  updated_at         :datetime         not null
#  user_id            :integer
#
# Indexes
#
#  index_jobs_on_deleted_at  (deleted_at)
#  index_jobs_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_df6238c8a6  (user_id => users.id)
#

require 'uri'

class Job < ApplicationRecord
  include AASM

  aasm do
    state :draft, :initial => true
    state :under_review
    state :approved
    state :edited
    state :disabled

    event :post_online do
      transitions :from => [:draft, :edited, :disabled], :to => :under_review
      success do
        # inform admin that there is a job post to be approved
        JobMailer.new_job(self).deliver
      end
    end

    event :publish do
      transitions :from => [:under_review, :disabled], :to => :approved

      after do
        # inform job ower that their job post is online
        JobMailer.job_published(self.id).deliver
        Notifier.post_job_to_slack(self.id)
      end
    end

    event :modify do
      transitions :from => [:under_review, :approved], :to => :edited
    end

    event :take_down do
      transitions :from => [:under_review, :edited, :approved], :to => :disabled
      after do
        # inform job ower that their job post was taken down
        JobMailer.job_unpublished(self.id).deliver
      end
    end
  end

  extend FriendlyId
  acts_as_paranoid

  belongs_to :user

  validates :company_name, presence: true
  validates :title, presence: true
  validates :employment_type, presence: true
  validates :experience, presence: true
  validates :from_salary, presence: true
  validates :currency, presence: true

  validates :external_link, url: true
  validates :apply_email, email: true

  before_validation :generate_unique_id, on: :create
  before_create :set_dates

  enum employment_type: [ :part_time, :full_time, :contract, :freelance, :temporary ]
  enum experience: [ :not_applicable, :internship, :entry_level, :associate, :mid_senior_level, :director, :executive ]
  enum education: [ :unspecified, :high_school_or_equivalent, :certification, :bachelor_degree, :master_degree, :doctorate, :professional ]

  friendly_id :custom_identifier

  def location_name
    country = ISO3166::Country[self.location]
    if country
      country.translations[I18n.locale.to_s] || country.name
    else
      ''
    end
  end

  def salary
    if to_salary.blank?
      "starting #{self.currency} #{self.from_salary}"
    else
      "between #{self.currency} #{self.from_salary} and #{self.to_salary}"
    end
  end

  def self.all_currencies
    [
      {
        title: 'Lebanese Pound (LBP)',
        code: 'LBP'
      },
      {
        title: 'United States Dollar (USD)',
        code: 'USD'
      },
      {
        title: 'United Arab Emirates Dirham (AED)',
        code: 'AED'
      },
      {
        title: 'Euro (EUR)',
        code: 'EUR'
      },
      {
        title: 'British Pound (GBP)',
        code: 'GBP'
      }
    ]
  end

  private

    def set_dates
      self.posted_on = Time.now.utc
      self.expires_on = Time.now.utc + 1.month
    end

    def generate_unique_id
      self.custom_identifier = Digest::SHA1.hexdigest(Time.now.to_s + rand(12341234).to_s + "#{self.title}")[1..24]
    end
end
