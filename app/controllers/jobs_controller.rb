class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy,
                                 :pre_approve, :approve, :take_down, :publish]
  # devise authentication required to access jobs
  before_action :authenticate_user!, :except => [:index, :show]
  before_action :check_user_profile_complete, :except => [:new, :index, :show]

  # GET /jobs
  def index
    @page_title       = 'Job board'
    @page_description = 'Technical jobs posted on MENA devs'
    @page_keywords    = AppSettings.meta_tags_keywords

    @jobs = Job.all_approved

    if user_signed_in?
      @jobs = Job.user_jobs(current_user) | @jobs
    end

    @jobs = @jobs.sort_by(&:updated_at).reverse

    @jobs = Kaminari.paginate_array(@jobs).page(params[:page])
  end

  # GET /list-jobs-admin
  def list_jobs
    @admin_jobs = Job.all.order(updated_at: :desc).page(params[:page])
    if !current_user.admin?
      flash[:notice] = "Not authorised"
    end

    render :admin_index
  end

  # GET /jobs/1
  def show
    @page_title       = @job.title
    @page_description = @job.title + ' at ' + @job.company_name
    @page_keywords    = AppSettings.meta_tags_keywords
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  def create
    @job = Job.new(job_params)
    @job.user = current_user

    if @job.save
      redirect_to @job, notice: 'Job post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /jobs/1
  def update
    if @job.update(job_params)
      @job.request_edit! unless @job.draft?
      redirect_to @job, notice: 'Job post was successfully updated.'
    else
      render :edit
    end
  end

  # PATCH/PUT /jobs/1/pre_approve
  def pre_approve
    if @job.request_approval!
      redirect_to @job, notice: 'Job post was successfully submitted for approval before made public.'
    else
      render :edit
    end
  end

  # PATCH/PUT /jobs/1/approve
  def approve
    if @job.publish!
      redirect_to @job, notice: 'The job is now live.'
    else
      render :edit
    end
  end

  # PATCH/PUT /jobs/1/take_down
  def take_down
    if @job.take_down!
      redirect_to @job, error: 'The job is no longer published.'
    else
      render :edit
    end
  end

  # PATCH/PUT /jobs/1/publish
  def publish
    if @job.publish!
      redirect_to @job, notice: 'The job is now live.'
    else
      render :edit
    end
  end

  # DELETE /jobs/1
  def destroy
    @job.destroy
    redirect_to jobs_url, error: 'The job was successfully removed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.friendly.find(params[:id]).decorate
    end

    # Only allow a trusted parameter "white list" through.
    def job_params
      params.require(:job).permit(:title, :description, :external_link,
                                  :custom_identifier, :posted_to_slack,
                                  :company_name, :apply_email, :employment_type,
                                  :experience, :from_salary, :country, :remote,
                                  :to_salary, :currency, :payment_term,
                                  :education, :number_of_openings)
    end
end
