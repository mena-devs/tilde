module JobsHelper
  def job_creator_name(job)
    if job.user
      link_to(job.user.try(:name), directory_user_path(job.user))
    else
      "Not defined"
    end
  end

  def posted_date(job, in_words = false)
    posted_date_str = ""

    if job.approved?
      if in_words
        posted_date_str = time_ago_in_words(job.posted_on)
      elsif !job.posted_on.blank?
        posted_date_str = job.posted_on.strftime('%b %e %Y ')
      end
    end

    return posted_date_str
  end

  def location_str(job)
    if job.country.blank? && job.remote?
      lc_str = "[remote]"
    end

    if !job.country.blank?
      lc_str =  " - " + job.location_name
    end

    return lc_str
  end

  def authorised_job_owner?(job)
    (user_signed_in? && job.user_id == current_user.id)
  end

  def show_job_status(job)
    job_status = ""
    selected = false

    Job.aasm.states.map(&:display_name).each do |custom_state_name|
      css_class = ""

      if job.aasm.human_state == custom_state_name
        css_class = "is-active"
        selected = true
      elsif selected == false
        css_class = "is-complete"
      end

      job_status += content_tag(:li, class: css_class) do
        content_tag(:span) do
          custom_state_name
        end
      end
    end

    return job_status
  end

  def visitor_name(user)
    if user.profile.complete?
      user.name
    else
      'Anonymous'
    end
  end
end
