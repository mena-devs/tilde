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

  def authorised_admin?
    (user_signed_in? && current_user.admin?)
  end

  def job_status(job)
    status = 'Job '

    if job.online?
      status += 'is online'
      alert_class = 'alert-success'
    elsif job.disabled?
      status += 'has expired'
      alert_class = 'alert-danger'
    else
      status += 'is ' + job.aasm_state.to_s.humanize(capitalize: false)
      alert_class = 'alert-warning'
    end

    return "<div class='alert #{alert_class} text-center' role='alert'>#{status}</div>"
  end

  def owner_job_actions(job)
    html_builder = ""

    if job.offline?
      html_builder += link_to("Delete", job_path(job), class: "button button-3d notopmargin button-red fright", method: :delete)
      html_builder += link_to("Edit", edit_job_path(job), class: "button button-3d notopmargin button-blue fright")

      if @job.draft?
        html_builder += '<br/>' + link_to("Submit for approval", pre_approve_job_path(job), class: "button button-3d notopmargin fright button-green", method: :put)
      end
    elsif job.online?
      html_builder += link_to("Edit", edit_job_path(job), class: "button button-3d notopmargin button-blue fright")
    end

    return html_builder.html_safe
  end

  def admin_job_actions(job)
    link_builder = ""

    if job.under_review?
      link_builder = link_to("Approve", approve_job_path(job), class: "button button-3d notopmargin fright button-green", method: :put)
    elsif job.online?
      link_builder = link_to("Take down", take_down_job_path(job), class: "button button-3d notopmargin fright button-red", method: :put)
    end

    return link_builder.html_safe
  end
end
