class SlackNotifierWorker
  include Sidekiq::Worker

  def perform(job_id)
    Notifier.post_job_to_slack(job_id)
  end
end
