class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Exceptions
  rescue_from ActionController::InvalidAuthenticityToken, with: :render_422
  rescue_from ActionView::MissingTemplate, with: :render_204

  # API access
  before_action :authenticate_with_token!, if: :api_request

  def after_sign_in_path_for(resource)
    session[:custom_identifier] = resource.custom_identifier
    root_path
  end

  def api_request
    if (request.original_url =~ /api\// || request.content_type =~ /application\/json/)
      return true
    end
    false
  end

  def check_user_profile_complete
    if user_signed_in? && current_user.profile && !current_user.profile.complete?
      redirect_to edit_user_profile_path(current_user), alert: 'Please complete your profile before proceeding'
    end
  end

  def authenticate_admin
    unless user_signed_in? && current_user.admin?
      redirect_to root_path, alert: "Not authorised"
    end
  end

  def user_is_owner?(objkt)
    (user_signed_in? && current_user.id == objkt.user_id)
  end

  def user_is_admin?
    (user_signed_in? && current_user.admin?)
  end

  def can_log_stats?(job)
    (job.approved? && (user_signed_in? && !current_user.admin?))
  end

  def can_see_stats?(job)
    (user_signed_in? && (job.user_id == current_user.id || current_user.admin?) )
  end

  def pagination_content(name, current_page, total_pages)
    pagination = {
      "current_page": current_page,
      "last_page": total_pages,
      "next_page_url": "#{AppSettings.application_host}/api/v1/#{name}?page[number]=#{current_page+1}",
      "prev_page_url": "#{AppSettings.application_host}/api/v1/#{name}?page[number]=#{current_page-1}"
    }

    return pagination
  end

  # Handle errors
  def handle_unverified_request
    raise(ActionController::InvalidAuthenticityToken)
  end

  def render_204
    render status: 422, json: { message: "No Content" }
  end

  def render_422
    redirect_to '/422'
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue
    render_404
  end

  def render_404
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def render_json_404
    render status: 404, json: { message: "Record not found" }
  end

  def render_json_422
    render status: 422, json: { message: "Invalid request" }
  end

  private
    def authenticate_with_token!
      auth_token = params[:auth_token].presence

      if (auth_token.nil? && request.headers['Authorization'].present?)
        auth_token = request.headers['Authorization'].split(' ').last
      end

      api_key = ApiKey.where(access_token: auth_token, enabled: true).first

      (auth_token.blank? || api_key.blank?) ? @user = nil : @user = api_key.user

      if (@user && Devise.secure_compare(api_key.access_token, auth_token))
        sign_in(@user)
      else
        respond_to do |format|
          format.json { render status: :unauthorized, json: { "ok": false, "error": "unauthorized" } }
          format.html { render status: :unauthorized, text: { "ok": false, "error": "unauthorized" } }
        end
      end
    end
end
