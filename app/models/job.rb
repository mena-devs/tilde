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
#  from_salary        :integer
#  id                 :integer          not null, primary key
#  number_of_openings :integer          default(1)
#  payment_term       :integer
#  posted_on          :datetime
#  posted_to_slack    :boolean          default(FALSE)
#  remote             :boolean          default(FALSE)
#  title              :string
#  to_salary          :integer
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
#  fk_rails_...  (user_id => users.id)
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

    event :request_edit do
      transitions :from => [:under_review, :edited, :approved], :to => :draft
    end

    event :request_approval do
      transitions :from => [:draft, :edited, :disabled], :to => :under_review
      success do
        # inform admins that there is a job post to be approved
        JobMailer.new_job(self).deliver
      end
    end

    event :publish do
      transitions :from => [:under_review, :disabled], :to => :approved

      after do
        # inform job ower that their job post is online
        JobMailer.job_published(self.id).deliver_later
        NotifierWorker.perform_async(self.id)
        notify_subscribers
        set_dates
      end
    end

    event :modify do
      transitions :from => [:under_review, :approved], :to => :edited
    end

    event :take_down do
      transitions :from => [:under_review, :edited, :approved], :to => :disabled
      after do
        # inform job ower that their job post was taken down
        JobMailer.job_unpublished(self.id).deliver_later
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
  validates :currency, presence: true, :if => Proc.new { |j| !j.from_salary.blank? }
  validates :payment_term, presence: true, :if => Proc.new { |j| !j.from_salary.blank? }

  validates :external_link, url: true
  validates :apply_email, email: true
  validates :to_salary, salary: true

  before_validation :generate_unique_id, on: :create
  before_validation :strip_whitespace, on: [:create, :update]

  enum employment_type: [ :part_time, :full_time, :contract, :freelance, :temporary ]
  enum experience: [ :not_applicable, :internship, :entry_level, :associate, :mid_senior_level, :director, :executive ]
  enum education: [ :unspecified, :high_school_or_equivalent, :certification, :bachelor_degree, :master_degree, :doctorate, :professional ]
  enum payment_term: [ :per_hour, :per_day, :per_month, :per_year, :per_contract ]

  friendly_id :custom_identifier

  scope :user_jobs, -> (user) { where(user_id: user.id) }
  scope :all_approved, -> { where(aasm_state: 'approved') }
  scope :live, -> { where.not(:posted_on => nil) }

  def location_name
    country_name = ""

    unless country.blank?
      country_str = ISO3166::Country[country]

      country_name = country_str.translations[I18n.locale.to_s] || country_str.name
    end

    country_name
  end

  def notify_subscribers
    User.job_alert_subscribers.each do |user|
      JobMailer.notify_subscriber(self.id, user).deliver_later
    end
  end

  def repost_job_to_slack
    Notifier.post_job_to_slack(self.id)
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

  def self.remove_expired_jobs
    Job.all.each |job|
      if job.created_at >= 1.month.ago
        job.take_down!
      end
    end
  end

  private

    def set_dates
      self.posted_on = Time.now.utc
      self.expires_on = Time.now.utc + 1.month
      save
    end

    def generate_unique_id
      self.custom_identifier = Digest::SHA1.hexdigest(Time.now.to_s + rand(12341234).to_s + "#{self.title}")[1..24]
    end

    def strip_whitespace
      self.company_name = self.company_name.strip unless self.company_name.nil?
      self.apply_email = self.apply_email.strip unless self.apply_email.nil?
    end
end
