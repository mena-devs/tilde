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
#

class JobSerializer
  include FastJsonapi::ObjectSerializer
  attributes :custom_identifier, :title, :currency

  belongs_to :user

  set_id :custom_identifier

  attribute :salary do |object|
    exp_salary = "#{object.from_salary}"
    unless object.to_salary.blank?
      exp_salary += " - #{object.to_salary}"
    end
  end

  attribute :creator_name do |object|
    "#{object.user.name}"
  end

  attribute :description do |object|
    "#{object.description.html_safe}"
  end
end
