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

    private

<<<<<<< HEAD
    def fetch_agreement(params = {})
      agreement = Agreement.new(controller_name, action_name, params)
      agreement.api_request
=======
    def test_agreement
      test_file = Wellness::Engine.root.join('spec', 'contracts', 'contract.pdf').to_s
      send_file test_file, filename: "#{agreement_params[:id]}.pdf"
>>>>>>> Move before_action hook to application controller
    end

    def agreement_params
      params.except(:format).permit(:id)
    end
  end
end
