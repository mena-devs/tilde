module Api
  module V1
    class InvitationsController < ApplicationController
      skip_before_action :verify_authenticity_token
      respond_to :json

      # devise authentication required to access invitations
      before_action :authenticate_user!, unless: :api_request

      # POST /invitations
      def create
        @invitation = Invitation.new(invitation_params)
        @invitation.medium = 'api'
        @invitation.code_of_conduct = true

        if user = User.where(uid: invitation_params[:slack_uid]).first
          @invitation.user = user
        end

        if @invitation.save
          render status: :created, json: { status: 201 }.to_json and return
        else
          render status: 422,
                 json: { message: @invitation.errors } and return
        end
      end

      private
        # Only allow a trusted parameter "white list" through.
        def invitation_params
          params.require(:invitation).permit(:slack_uid, :invitee_name,
                                             :invitee_email, :invitee_title,
                                             :invitee_company)
        end
    end
  end
end
