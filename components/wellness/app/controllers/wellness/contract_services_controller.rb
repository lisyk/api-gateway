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
      if bad_response?
        render json: {
          errors: response_errors,
          warnings: response_warnings
        }
      else
        @response.present?
        render json: @response
      end
    end

    private

    def bad_response?
      response_errors.present? || response_warnings.present?
    end

    def response_errors
      any_errors = @response['serviceConsumptionList'].detect { |i| i.key? 'errors' }
      any_errors ? any_errors['errors'] : []
    end

    def response_warnings
      any_warnings = @response['serviceConsumptionList'].detect { |i| i.key? 'warnings' }
      any_warnings ? any_warnings['warnings'] : []
    end

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
      RequestTranslation.new(request, skip_default).translate_request.to_json
    end
  end
end
