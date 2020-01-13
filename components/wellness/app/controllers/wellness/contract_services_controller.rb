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

    def create
      translated_request = translate(request, true)
      @response ||= consume_service(translated_request)
      if @response.is_a?(Hash) && @response.keys == ['errors']
        render json: @response,
               status: :bad_request
      elsif @response.present?
        render json: @response
      else
        render json: { errors: ['Service consumption error.'] },
               status: :unprocessable_entity
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

    def consume_service(request)
      contract_service = ContractService.new(controller_name, action_name)
      contract_service.api_post(request)
    end

    def translate(request, skip_default)
      RequestTranslation.new(request, controller_name, skip_default).translate_request.to_json
    end
  end
end
