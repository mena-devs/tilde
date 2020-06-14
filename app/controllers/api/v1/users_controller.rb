module Api
  module V1
    class UsersController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :render_json_404

      skip_before_action :verify_authenticity_token
      before_action :set_user, only: [:show]

      respond_to :json

      # GET /api/v1/users
      def index
        users = verified_users.joins(:profile)
        users_count = users.count

        if params[:page] && params[:page][:number]
          users = users.paginate(page: params[:page][:number], per_page: 10)
          total_pages = (users_count / 10).ceil
          current_page = params[:page][:number]
        else
          current_page = 1
        end

        options = { meta: { total: users_count } }

        users_hash = UserSerializer.new(users).serializable_hash
        users_hash.merge!(options)
        users_hash.merge!(pagination: pagination_content('users', current_page, total_pages))

        render json: users_hash
      end

      # GET /api/v1/users/:custom_identifier
      def show
        user_hash = UserSerializer.new(@user).serializable_hash

        render json: user_hash
      end

      # GET /users/search/
      def search
        if (!params.has_key?(:query) || params[:query].kind_of?(String))
          render_json_422 and return
        end

        users = User.search(params[:query])
        users_count = users.count

        options = { meta: { total: users_count } }

        users_hash = UserSerializer.new(users).serializable_hash
        users_hash.merge!(options)
        
        if users.blank?
          render_json_404 and return
        else
          render json: users_hash
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.friendly.find(params[:id])
        end
    
        def verified_users
          User.verified
        end
    end
  end
end
