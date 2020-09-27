class TwitterApi
  attr_accessor :client

  def initialize
    begin
      # @client = Buffer::Client.new(AppSettings.buffer_access_token)
    rescue StandardError => e
      logger.error("An error occured: #{e}")
    end
  end

  def prepare_tweet(job_id)
    job = Job.find(job_id)

    tweet_text = "#{job.company_name.titleize} is looking to hire a #{job.title}"
    tweet_text += " in ##{job.location_name}" unless job.location_name.blank?
    tweet_text += ". More information here https://#{AppSettings.application_host}/jobs/#{job.to_param}"
    if !job.twitter_handle.blank?
      if job.twitter_handle.start_with?('@')
        tweet_text += (" " + job.twitter_handle)
      else
        tweet_text += (" @" + job.twitter_handle)
      end
    end

    return tweet_text
  end

  def post_new_tweet(job_id)
    @client.create_update(
      body: {
        text:
          self.prepare_tweet(job_id),
        profile_ids: self.get_profile_id
      }
    )
  end

  def get_profile_id
    @client.profiles.first._id
  end
end
