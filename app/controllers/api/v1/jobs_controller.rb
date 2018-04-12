module Api
  module V1
    class JobsController < ApplicationController
      skip_before_action :verify_authenticity_token

      # devise authentication required to access invitations
      before_action :authenticate_user!, unless: :api_request

      respond_to :json

      # GET /jobs
      def index
        approved_jobs = Job.all_approved
        if params[:page] && params[:page][:number]
          jobs = approved_jobs.paginate(page: params[:page][:number], per_page: 10)
          total_pages = (Job.all_approved.count / 10).ceil
          current_page = params[:page][:number]
        else
          jobs = approved_jobs
          current_page = 1
        end

        pagination = {
          "current_page": current_page,
          "last_page": total_pages,
          "next_page_url": "#{AppSettings.application_host}/api/v1/jobs?page[number]=#{current_page+1}",
          "prev_page_url": "#{AppSettings.application_host}/api/v1/jobs?page[number]=#{current_page-1}"
        }

        options = { meta: { total: jobs.count } }

        jobs_hash = JobSerializer.new(jobs, options).serializable_hash

        render json: { jobs: jobs_hash, pagination: pagination }
      end

      # GET /jobs/:custom_identifier
      def show
        job = Job.friendly.where(params[:custom_identifier])

        job_hash = JobSerializer.new(job).serializable_hash

        render json: { job: job_hash }
      end
    end
  end
end
