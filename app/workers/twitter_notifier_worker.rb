class TwitterNotifierWorker
  include Sidekiq::Worker

  def perform(job_id)
    twitter_api = TwitterApi.new
    twitter_api.post_new_tweet(job_id)
  end
end
