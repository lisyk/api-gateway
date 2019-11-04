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

    private

    def fetch_services
      services = PlanService.new(controller_name, action_name)
      services.api_request
    end
  end
end
