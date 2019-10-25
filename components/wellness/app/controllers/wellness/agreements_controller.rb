# frozen_string_literal: true

module Wellness
  class AgreementsController < Wellness::ApplicationController
    def show
      @agreement ||= demo_client_ready ? client_request(agreement_params) : test_agreement
      send_data @agreement.body, filename: "#{agreement_params[:id]}.pdf"
    end

    private

    def test_agreement
      test_file = Wellness::Engine.root.join('spec', 'contracts', 'contract.pdf').to_s
      send_file test_file, filename: "#{agreement_params[:id]}.pdf"
    end

    def agreement_params
      params.except(:format).permit(:id)
    end
  end
end
