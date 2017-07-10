class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy, :approve, :take_down, :publish]
  # devise authentication required to access jobs
  before_action :authenticate_user!, :except => [:new, :index, :show]

  # GET /jobs
  def index
    @jobs = Job.approved.order(updated_at: :desc).page(params[:page])
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
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
    if (current_user != @job.user || !current_user.admin?)
      redirect_to @job, error: 'Not authorised'
    end
  end

  # POST /jobs
  def create
    @job = Job.new(job_params)
    @job.user = current_user
    @job.post_online

    if @job.save
      redirect_to @job, notice: 'Job post was successfully created and is awaiting approval before it appears live.'
    else
      render :new
    end
  end

  # PATCH/PUT /jobs/1
  def update
    if @job.update(job_params)
      redirect_to @job, notice: 'Job post was successfully updated.'
    else
      render :edit
    end
  end

  # PATCH/PUT /jobs/1/approve
  def approve
    if @job.publish!
      redirect_to @job, notice: 'The job is now live on the Job Board.'
    else
      render :edit
    end
  end

  # PATCH/PUT /jobs/1/take_down
  def take_down
    if @job.take_down!
      redirect_to @job, error: 'The job is no longer published live.'
    else
      render :edit
    end
  end

  # PATCH/PUT /jobs/1/publish
  def publish
    if @job.publish!
      redirect_to @job, notice: 'The job is now live on the Job Board.'
    else
      render :edit
    end
  end

  # DELETE /jobs/1
  def destroy
    @job.destroy
    redirect_to jobs_url, error: 'Job post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def job_params
      params.require(:job).permit(:title, :description, :job_description_location,
                                  :custom_identifier, :posted_on, :expires_on,
                                  :aasm_state, :posted_to_slack, :user_id,
                                  :company_name, :apply_email, :job_type,
                                  :level, :paid, :location, :remote_ok)
    end
end
