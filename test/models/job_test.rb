# == Schema Information
#
# Table name: jobs
#
#  id                 :bigint           not null, primary key
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

require 'test_helper'

class JobTest < ActiveSupport::TestCase
  test "creation of a new job" do
    user_one = users(:one)
    job = Job.new(title: "CTO",
                  description: "MyText",
                  country: "Lebanon",
                  custom_identifier: "sjhdgkjsdhflgjhsfdghlsdf",
                  user: user_one,
                  company_name: "MyString",
                  apply_email: "two@example.com",
                  employment_type: 1,
                  from_salary: 1000,
                  to_salary: 1500,
                  currency: "usd",
                  payment_term: 2,
                  experience: 2)

    assert job.valid?
    assert job.save
  end

  test "job with invalid salary" do
    user_one = users(:one)
    job = Job.new(title: "CTO",
                  description: "MyText",
                  country: "Lebanon",
                  custom_identifier: "sjhdgkjsdhflgjhsfdghlsdf",
                  user: user_one,
                  company_name: "MyString",
                  apply_email: "two@example.com",
                  employment_type: 1,
                  from_salary: 2000,
                  to_salary: 1500,
                  currency: "usd",
                  payment_term: 2,
                  experience: 2)

    assert_equal false, job.valid?
    assert_equal(["cannot be less than starting salary"], job.errors.messages[:to_salary])
  end

  test "publish a job that is under_review" do
    job = jobs(:one)

    assert job.publish!
  end

  test "error when publishing a job that is not under_review" do
    job = jobs(:two)

    assert_raises AASM::InvalidTransition do
      job.publish!
    end
  end
end
