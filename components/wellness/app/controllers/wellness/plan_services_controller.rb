# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class PlanServicesController < Wellness::ApplicationController
    def index
      # TODO: needs to be updated from DEMO to PROD
      @plan_services ||= fetch_services if demo_client_ready
      if @plan_services.present?
        render json: { plans: @plan_services }
      else
        render json: { errors: ['Plan services are not available.'] }, status: :not_found
      end
    end

    def show
      # TODO: needs to be updated from DEMO to PROD
      @service ||= fetch_services(service_params) if demo_client_ready
      if @service.present?
        render json: { service: @service }
      else
        render json: { errors: ['Service unavailable.'] }, status: :not_found
      end
    end

    private

    def fetch_services(params = {})
      services = PlanService.new(controller_name, action_name, params)
      services.api_request
    end

    def service_params
      params.except(:format).permit(:id)
    end
  end
end
