# == Schema Information
#
# Table name: jobs
#
#  id                 :integer          not null, primary key
#  aasm_state         :string
#  title              :string
#  description        :text
#  external_link      :string
#  country            :string
#  remote             :boolean          default(FALSE)
#  custom_identifier  :string
#  posted_on          :datetime
#  expires_on         :datetime
#  posted_to_slack    :boolean          default(FALSE)
#  user_id            :integer
#  company_name       :string
#  apply_email        :string
#  to_salary          :integer
#  employment_type    :integer
#  number_of_openings :integer          default(1)
#  experience         :integer
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  from_salary        :integer
#  currency           :string
#  education          :string
#  payment_term       :integer
#  twitter_handle     :string
#  slug               :string
#  hired              :boolean          default(FALSE)
#  equity             :boolean
#

require 'uri'

class Job < ApplicationRecord
  include AASM, CountryName, TextHelpers

  aasm do
    state :draft, :initial => true
    state :under_review
    state :approved
    state :edited
    state :disabled

    event :request_edit do
      transitions :from => [:under_review, :edited, :approved, :disabled], :to => :draft
    end

    event :request_approval do
      transitions :from => [:draft, :edited, :disabled], :to => :under_review
      success do
        email_notification_job_submitted
      end
    end

    event :publish do
      transitions :from => [:under_review, :disabled], :to => :approved

      after do
        unless self.posted_to_slack?
          email_notification_job_published
          slack_and_buffer_notification_job_published
          email_notification_to_subscribed_members
          set_dates
        end
      end
    end

    event :modify do
      transitions :from => [:under_review, :approved, :disabled], :to => :edited
    end

    event :take_down do
      transitions :from => [:under_review, :edited, :approved], :to => :disabled
      after do
        email_notification_job_unpublished
      end
    end
  end

  extend FriendlyId
  acts_as_paranoid

  belongs_to :user
  has_many :job_statistics, :dependent => :destroy

  validates :company_name, presence: true
  validates :title, presence: true
  validates :employment_type, presence: true
  validates :experience, presence: true
  validates :from_salary, presence: true
  validates :currency, presence: true, :if => Proc.new { |j| j.salary_is_set? }
  validates :payment_term, presence: true, :if => Proc.new { |j| j.salary_is_set? }

  validates :external_link, url: true
  validates :apply_email, email: true
  validates :to_salary, salary: true

  before_validation :generate_unique_id, on: :create
  before_validation :strip_whitespace, on: [:create, :update]

  enum employment_type: [ :part_time, :full_time, :contract, :freelance, :temporary ]
  enum experience: [ :not_applicable, :internship, :entry_level, :associate, :mid_senior_level, :director, :executive ]
  enum education: [ :unspecified, :high_school_or_equivalent, :certification, :bachelor_degree, :master_degree, :doctorate, :professional ]
  enum payment_term: [ :per_hour, :per_day, :per_month, :per_year, :per_contract ]

  friendly_id :title, use: :slugged

  scope :user_jobs, -> (user) { where(user_id: user.id) }
  scope :approved, -> { where(aasm_state: 'approved') }
  scope :user_draft, -> { where(aasm_state: ['draft', 'under_review', 'edited']) }
  scope :user_expired, -> { where(aasm_state: 'disabled') }
  scope :live, -> { where.not(:posted_on => nil) }

  def offline?
    (self.draft? || self.under_review? || self.disabled?) ? true : false
  end

  def online?
    self.approved?
  end

  def salary_is_set?
    self.from_salary.blank? ? false : true
  end

  def location_name
    country_name(country)
  end

  def slack_and_buffer_notification_job_published
    SlackNotifierWorker.perform_async(self.id)
    self.update(posted_to_slack: true)
    BufferNotifierWorker.perform_async(self.id)
  end

  def email_notification_job_submitted
    # inform admins that there is a job post to be approved
    JobMailer.new_job(self.id).deliver_later
  end

  def email_notification_job_published
    # inform job owner that their job post is online
    JobMailer.job_published(self.id).deliver_later
  end

  def email_notification_job_unpublished
    # inform job ower that their job post was taken down
    JobMailer.job_unpublished(self.id).deliver_later
  end

  def email_notification_to_subscribed_members
    User.job_alert_subscribers.each do |user|
      JobMailer.notify_subscriber(self.id, user.id).deliver_later
    end
  end

  def repost_job_to_slack
    SlackNotifierWorker.perform_async(self.id)
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
    date = Date.today
    start_date = date
    end_date = date.months_ago(1)

    Job.approved.where('posted_on < ?', end_date).each do |job|
      job.take_down!
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
