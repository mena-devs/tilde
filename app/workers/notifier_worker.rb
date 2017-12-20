class NotifierWorker
  include Sidekiq::Worker

  def perform(job_id)
    Notifier.post_job_to_slack(job_id)
    buffer_api = BufferApi.new
    buffer_api.post_new_job(job_id)
  end
end
