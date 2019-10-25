# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class AgreementsController < ::Api::V1::ApiController
    before_action :user_authorized?

    def show
      @agreement ||= demo_client_ready ? client_request(agreement_params) : test_agreement
      send_data @agreement.body, filename: "#{agreement_params[:id]}.pdf"
    end

    def update
      @response ||= demo_client_ready ? client_request(agreement_params) : test_agreement_upload
      if @response.status == 200
        render json: { success: ['Signed agreement posted successfully'] }, status: :success
      else
        render json: { errors: [@response.reason_phrase] }, status: @response.status
      end
    end

    private

    def client_request(params = {})
      WellnessPlans.new.api_request(controller_name, action_name, params)
    end

    def test_agreement
      test_file = Wellness::Engine.root.join('spec', 'contracts', 'contract.pdf').to_s
      send_file test_file, filename: "#{agreement_params[:id]}.pdf"
    end

    def test_agreement_upload; end

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
