class BufferApi
  attr_accessor :client

  def initialize
    @client = Buffer::Client.new(AppSettings.buffer_access_token)
  end

  def post_new_job(job_id)
    job = Job.find(job_id)

    @client.create_update(
      body: {
        text:
          "#{job.company_name.titleize} is looking to hire a '#{job.title}' in ##{job.location_name}. Check out the job details here https://#{AppSettings.application_host}/jobs/#{job.custom_identifier}.",
        profile_ids: self.get_profile_id
      }
    )
  end

  def get_profile_id
    @client.profiles.first._id
  end
end
