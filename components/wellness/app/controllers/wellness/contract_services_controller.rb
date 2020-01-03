# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class ContractServicesController < Wellness::ApplicationController
    def index
      @contract_services ||= fetch_services
      if @contract_services.present?
        render json: { contract_services: @contract_services }
      else
        render json: { errors: ['Contract services are not available.'] }, status: :not_found
      end
    end

    private

    def fetch_services
      services = ContractService.new(controller_name, action_name, params, query_params)
      services.available_services
    end

    def query_params
      params.except(:format).permit(:contractId)
    end
  end
end
