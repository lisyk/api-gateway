# frozen_string_literal: true

module Wellness
  class AgreementsController < Wellness::ApplicationController
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
      @response ||= fetch_agreement(agreement_params) if demo_client_ready
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

    def agreement_params
      params.except(:format).permit(:id, :contract)
    end
  end
end
