module Api
  module V1
    class JobsController < ApplicationController
      skip_before_action :verify_authenticity_token

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

        options = { meta: { total: jobs.count } }

        jobs_hash = JobSerializer.new(jobs).serializable_hash
        jobs_hash.merge!(options)
        jobs_hash.merge!(pagination: pagination_content('jobs', current_page, total_pages))

        render json: jobs_hash
      end

      # GET /jobs/:id
      def show
        job = Job.friendly.where(custom_identifier: params[:id])

        job_hash = JobSerializer.new(job).serializable_hash

        render json: job_hash
      end
    end
  end
end
