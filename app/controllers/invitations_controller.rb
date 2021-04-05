class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :edit, :update, :destroy, :resend, :approve]
  # devise authentication required to access invitations
  before_action :authenticate_user!, unless: :api_request
  respond_to :html

  # GET /invitations
  def index
    if params.has_key?(:state)
      invitations = Invitation.where(user: current_user.id)
      if params[:state] == 'accepted'
        invitations = invitations.where(aasm_state: 'accepted')
      elsif params[:state] == 'pending'
        invitations = invitations.where(aasm_state: ['sent', 'resent'])
      end
    else
      invitations = Invitation.all_sent(current_user.id)
    end

    @invitations = invitations.order(updated_at: :desc).page(params[:page])
  end

  # GET /list-invitations-admin
  def list_invitations
    @admin_invitations = Invitation.all.order(updated_at: :desc).page(params[:page])

    unless current_user.admin?
      redirect_to root_path, error: "You are not authorised to access this resource" and return
    end

    render :template => 'invitations/admin_index'
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
      redirect_to invitations_path, notice: 'Your application was received and will be processed shortly.'
    else
      render :new
    end
  end

  # PATCH/PUT /invitations/1
  def update
    if @invitation.update(invitation_params)
      redirect_to invitations_path, notice: 'Invitation was successfully updated.'
    else
      render :edit
    end
  end

  # PATCH/PUT /invitations/1/resend
  def resend
    if current_user.admin? && @invitation.resend_invitation
      redirect_to list_invitations_admin_path, notice: 'Invitation was resent.'
    else
      @invitations = Invitation.all_sent(current_user.id).order(updated_at: :desc).page(params[:page])

      render :index
    end
  end

  # PATCH/PUT /invitations/1/approve
  def approve
    if @invitation.send_invite!
      redirect_to list_invitations_admin_path, notice: 'Invitation was approved.'
    else
      render :list_invitations
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
