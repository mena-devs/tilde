require 'test_helper'

class JobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @job = jobs(:one)
  end

  test "should get index" do
    get jobs_url
    assert_response :success
  end

  test "should get new" do
    get new_job_url
    assert_response :success
  end

  test "should create job" do
    assert_difference('Job.count') do
      post jobs_url, params: { job: { apply_email: @job.apply_email, approved: @job.approved, company_name: @job.company_name, custom_identifier: @job.custom_identifier, description: @job.description, expires_on: @job.expires_on, job_location: @job.job_location, job_type: @job.job_type, level: @job.level, paid: @job.paid, posted_on: @job.posted_on, posted_to_slack: @job.posted_to_slack, state: @job.state, title: @job.title, user_id: @job.user_id } }
    end

    assert_redirected_to job_url(Job.last)
  end

  test "should show job" do
    get job_url(@job)
    assert_response :success
  end

  test "should get edit" do
    get edit_job_url(@job)
    assert_response :success
  end

  test "should update job" do
    patch job_url(@job), params: { job: { apply_email: @job.apply_email, approved: @job.approved, company_name: @job.company_name, custom_identifier: @job.custom_identifier, description: @job.description, expires_on: @job.expires_on, job_location: @job.job_location, job_type: @job.job_type, level: @job.level, paid: @job.paid, posted_on: @job.posted_on, posted_to_slack: @job.posted_to_slack, state: @job.state, title: @job.title, user_id: @job.user_id } }
    assert_redirected_to job_url(@job)
  end

  test "should destroy job" do
    assert_difference('Job.count', -1) do
      delete job_url(@job)
    end

    assert_redirected_to jobs_url
  end
end
