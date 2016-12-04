class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]
  # devise authentication required to access invitations
  before_action :authenticate_user!, :except => [:new, :create]
  # GET /invitations
  def index
    @invitations = Invitation.all
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
    invitation_params[:user_id] = nil #current_user.id || nil
    @invitation = Invitation.new(invitation_params)

    if @invitation.save
      redirect_to root_path, notice: 'Invitation was successfully sent.'
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

  # DELETE /invitations/1
  def destroy
    @invitation.destroy
    redirect_to invitations_url, notice: 'Invitation was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def invitation_params
      params.require(:invitation).permit(:user_id, :invitee_name, :invitee_email, :invitee_title, :invitee_company, :invitee_location, :delivered, :registered)
    end
end
