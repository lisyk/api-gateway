# frozen_string_literal: true

module Wellness
  class AgreementsController < Wellness::ApplicationController
    def show
      # TODO: needs to be updated from DEMO to PROD
      @agreement ||= fetch_agreement(agreement_params) if demo_client_ready
      if @agreement.present?
        send_data @agreement.body, filename: "#{agreement_params[:id]}.pdf"
      else
        render json: { errors: ['Agreement unavailable.'] }, status: :not_found
      end
    end

    def update
      # TODO: needs to be updated from DEMO to PROD
      @response ||= put_agreement(agreement_params) if demo_client_ready
      if @response.present? && @response['errors'].nil?
        render json: { success: ['Signed agreement posted successfully.'] },
               status: :success
      else
        render json: { errors: @response['errors'] || ['No response returned'] },
               status: :unprocessable_entity
      end
    end

    private

    def fetch_agreement(params = {})
      agreement = Agreement.new(controller_name, action_name, params)
      agreement.api_request
    end

    def put_agreement(params = {})
      body = {
        id: params[:id],
        documentFileBase64: Base64.strict_encode64(File.read(params[:contract].tempfile))
      }
      agreement = Agreement.new(controller_name, action_name, params)
      agreement.api_put(body, headers)
    end

    def agreement_params
      params.except(:format).permit(:id, :contract)
    end
  end
end
