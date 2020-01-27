# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class PlanServicesController < Wellness::ApplicationController
    def index
      @plan_services ||= fetch_services
      if @plan_services.present?
        render json: { services: @plan_services }
      else
        render json: { errors: ['Plan services are not available.'] }, status: :not_found
      end
    end

    def show
      @service ||= fetch_services(service_params)
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
