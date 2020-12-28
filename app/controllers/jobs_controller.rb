class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy,
                                 :pre_approve, :approve, :take_down, :feedback]
  # devise authentication required to access jobs
  before_action :authenticate_user!, :except => [:index, :show, :list_jobs]
  before_action :check_user_profile_complete, :except => [:index, :show]

  # GET /jobs
  def index
    @page_title       = 'Job board'
    @page_description = 'Technical & software development jobs listed on MENAdevs'
    @page_keywords    = AppSettings.meta_tags_keywords

    @jobs = Job.approved_jobs.order(:posted_on).reverse_order

    if (user_signed_in? && params.has_key?(:state))
      filter_by_params(current_user)
    end

    @jobs = Kaminari.paginate_array(@jobs).page(params[:page]).per(25)
  end

  # GET /list-jobs-admin
  def list_jobs
    @jobs = Job.all.order(:created_at).reverse_order

    if params.has_key?(:state)
      filter_by_params
    end

    @jobs = Kaminari.paginate_array(@jobs).page(params[:page]).per(25)

    render :admin_index
  end

  # GET /jobs/1
  def show
    @page_title       = @job.title
    @page_description = @job.title + ' at ' + @job.company_name
    @page_keywords    = AppSettings.meta_tags_keywords

    if can_log_stats?(@job)
      JobStatistic.increment(@job.id, current_user.id)
    end

    if can_see_stats?(@job)
      @job_statistics = JobStatistic.where(job_id: @job.id).order(counter: :desc)
    end
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # POST /jobs
  def create
    @job = Job.new(job_params)

    if user_signed_in?
      @job.user_id = current_user.id
    end

    if @job.save
      redirect_to(@job, notice: 'Job post was successfully created.')
    else
      render :new
    end
  end

  # GET /jobs/1/edit
  def edit
    unless ((user_signed_in? && current_user.id == @job.user_id) || current_user.admin?)
      redirect_to(@job, notice: 'You are not authorised to access this job post.')
    end
  end

  # PATCH/PUT /jobs/1
  def update
    if @job.update(job_params)
      @job.request_edit! unless @job.draft?

      redirect_to(@job, notice: 'Job post was successfully updated.')
    else
      render :edit
    end
  end

  # DELETE /jobs/1
  def destroy
    if ((user_signed_in? && current_user.id == @job.user_id) || current_user.admin?)
      @job.delete
      redirect_to(jobs_path, notice: 'Job post was successfully deleted.')
    else
      render @job, notice: 'You are not authorised to access this job post.'
    end
  end

  # PATCH/PUT /jobs/1/pre_approve
  def pre_approve
    if @job.request_approval!
      redirect_to(@job, notice: 'The job post was successfully submitted for approval before made public.')
    else
      render :edit
    end
  end

  # PATCH/PUT /jobs/1/approve
  def approve
    if @job.publish!
      redirect_to(@job, notice: 'The job is now live.')
    else
      render :edit
    end
  end

  # PATCH/PUT /jobs/1/reject
  def reject
    if @job.publish!
      redirect_to(@job, notice: 'The job is now live.')
    else
      render :edit
    end
  end

  # PATCH/PUT /jobs/1/take_down
  def take_down
    if @job.take_down!
      redirect_to(@job, notice: 'The job is no longer published.')
    else
      render :edit
    end
  end

  # PATCH/PUT /jobs/1/feedback
  def feedback
    render :feedback
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.where(custom_identifier: params[:id]).or(Job.where(slug: params[:id]))
      not_found if @job.blank?
      @job = @job.decorate.first
    end

    def filter_by_params(user = nil)
      user_jobs = user.nil? ? Job.all : Job.user_jobs(user)
      state_params = params[:state]

      case state_params
      when 'user'
        @jobs = user_jobs
      when 'draft'
        @jobs = user_jobs.draft_jobs
      when 'pending'
        @jobs = user_jobs.pending_jobs
      when 'expired'
        @jobs = user_jobs.expired_jobs
      end
    end

    # Only allow a trusted parameter "white list" through.
    def job_params
      params.require(:job).permit(:title, :description, :external_link,
                                  :custom_identifier, :posted_to_slack,
                                  :company_name, :apply_email, :employment_type,
                                  :experience, :from_salary, :country, :remote,
                                  :to_salary, :currency, :payment_term,
                                  :education, :number_of_openings,
                                  :twitter_handle, :hired, :equity)
    end
end
