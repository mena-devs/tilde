class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]
  # devise authentication required to access invitations
  before_action :authenticate_user!, unless: :api_request
  # GET /invitations
  def index
    if current_user.admin?
      @invitations = Invitation.all.order(updated_at: :desc).page(params[:page])
    else
      @invitations = Invitation.sent(current_user.id).order(updated_at: :desc).page(params[:page])
    end
  end

  # GET /invitations/1
  def show
  end

  # GET /invitations/new
  def new
    @invitation = Invitation.new
  end

  # GET /invitations/1/edit
  def edit
  end

  # POST /invitations
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.user = current_user
    @invitation.medium = 'web'

    if @invitation.member_application?
      @invitation.invitee_name = current_user.name
      @invitation.invitee_email = current_user.email
    end

    if @invitation.save
      redirect_to root_path, notice: 'Your application was received and will be processed shortly.'
    else
      render :new
    end
  end

  # PATCH/PUT /invitations/1
  def update
    if @invitation.update(invitation_params)
      redirect_to @invitation, notice: 'Invitation was successfully updated.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def invitation_params
      params.require(:invitation).permit(:user_id, :invitee_name,
                                         :invitee_email, :invitee_title,
                                         :invitee_company, :invitee_location,
                                         :invitee_introduction,
                                         :delivered, :registered,
                                         :code_of_conduct, :member_application)
    end
end
