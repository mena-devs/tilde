module JobsHelper
  def job_creator_name(job)
    if job.user
      job.user.try(:name)
    else
      "Not defined"
    end
  end

  def posted_date(job, in_words = false)
    posted_date_str = "Not online yet"

    if job.approved?
      if in_words
        posted_date_str = time_ago_in_words(job.posted_on)
      else
        posted_date_str = job.posted_on.strftime('%A %e %B %Y ')
      end
    end

    return posted_date_str
  end

  def location_str(job)
    if job.country.blank? && job.remote?
      lc_str = "[remote]"
    end

    if !job.country.blank? && job.remote?
      lc_str =  " - " + job.location_name + " [remote]"
    elsif !job.country.blank? && !job.remote?
      lc_str =  " - " + job.location_name
    end

    return lc_str
  end
end
