# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class AgreementsController < ::Api::V1::ApiController
    before_action :user_authorized?

    def show
      # TODO: needs to be updated from DEMO to PROD
      @agreement ||= fetch_agreement(agreement_params) if demo_client_ready
      if @agreement
        send_data @agreement.body, filename: "#{agreement_params[:id]}.pdf"
      else
        render json: { errors: ['Agreement unavailable.'] }, status: :not_found
      end
    end

    def update
      @response ||= demo_client_ready ? client_request(agreement_params) : test_agreement_upload
      status = @response.status
      if status == 200
        render json: { success: ['Signed agreement posted successfully'] }, status: status
      else
        render json: { errors: [@response.reason_phrase] }, status: status
      end
    end

    private

    def fetch_agreement(params = {})
      agreement = Agreement.new(controller_name, action_name, params)
      agreement.api_request
    end

    def test_agreement_upload
      ActionDispatch::Response.new
    end

    def user_authorized?
      return unless @current_user != 'authorized'

      render json: { errors: ['You are not authorized'] }, status: :forbidden
    end

    def demo_client_ready
      Settings.api.vcp_wellness.demo_client_ready
    end

    def agreement_params
      params.except(:format).permit(:id, :contract)
    end
  end
end
