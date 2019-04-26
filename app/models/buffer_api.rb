class BufferApi
  attr_accessor :client

  def initialize
    begin
      @client = Buffer::Client.new(AppSettings.buffer_access_token)
    rescue StandardError => e
      logger.error("An error occured: #{e}")
    end
  end

  def prepare_tweet(job_id)
    job = Job.find(job_id)

    tweet_text = "#{job.company_name.titleize} is looking to hire a #{job.title}"
    tweet_text += " in ##{job.location_name}" unless job.location_name.blank?
    tweet_text += ". More information here https://#{AppSettings.application_host}/jobs/#{job.to_param}"
    tweet_text += (" " + job.twitter_handle) unless job.twitter_handle.blank?

    return tweet_text
  end

  def post_new_job(job_id)
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
