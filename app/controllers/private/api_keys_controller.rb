class Private::ApiKeysController < ApplicationController
  before_action :set_api_key, only: [:update_state, :update_access]

  # devise authentication required to access invitations
  before_action :authenticate_user!
  before_action :is_admin

  # GET /private/api_keys
  def index
    @api_keys = ApiKey.joins(:user).order(updated_at: :desc).page(params[:page])
  end

  # PATCH/PUT /private/api_keys/:id/update_state
  def update_state
    @api_key.toggle(:enabled)
    if @api_key.save
      redirect_to(private_api_keys_path, notice: 'API Key state was successfully updated.')
    else
      redirect_to(private_api_keys_path, error: 'An error has occured while updating state.')
    end
  end

  # PATCH/PUT /private/api_keys/:id/update_access
  def update_access
    if @api_key.read?
      @api_key.access_type = :read_write
    else
      @api_key.access_type = :read
    end

    if @api_key.save
      redirect_to(private_api_keys_path, notice: 'API Key access type was successfully updated.')
    else
      redirect_to(private_api_keys_path, error: 'An error has occured while updating access type.')
    end
  end

  private
    def is_admin
      unless user_signed_in? && current_user.admin?
        redirect_to root_path, error: "You are not authorised to access this resource" and return
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_api_key
      @api_key = ApiKey.find(params[:id])
    end
end