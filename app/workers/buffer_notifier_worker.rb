class BufferNotifierWorker
  include Sidekiq::Worker

  def perform(job_id)
    buffer_api = BufferApi.new
    buffer_api.post_new_job(job_id)
  end
end
