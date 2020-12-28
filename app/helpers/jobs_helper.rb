module JobsHelper
  def job_creator_name(job)
    if job.user
      link_to(job.user.try(:name), directory_user_path(job.user))
    else
      "Not defined"
    end
  end

  def posted_date(job, in_words = false)
    posted_date_str = "Not online yet"

    if job.approved?
      if in_words
        posted_date_str = time_ago_in_words(job.posted_on)
      elsif !job.posted_on.blank?
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

  def authorised_job_owner?(job)
    (user_signed_in? && job.user_id == current_user.id)
  end

  def job_status(job)
    status = 'Job '

    if job.online?
      status += 'is online'
      alert_class = 'alert alert-success text-center'
    elsif job.disabled?
      status += 'has expired'
      alert_class = 'alert alert-danger text-center'
    else
      status += 'is ' + job.aasm_state.to_s.humanize(capitalize: false)
      alert_class = 'alert alert-warning text-center'
    end
    
    return content_tag(:div, status, class: alert_class, role: 'alert')
  end

  def visitor_name(user)
    if user.profile.complete?
      user.name
    else
      'Anonymous'
    end
  end
end
