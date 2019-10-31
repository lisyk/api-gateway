# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class PlanServicesController < ::Api::V1::ApiController
    before_action :user_authorized?

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

    def user_authorized?
      return unless @current_user != 'authorized'

      render json: { errors: ['You are not authorized'] }, status: :forbidden
    end

    def demo_client_ready
      Settings.api.vcp_wellness.demo_client_ready
    end
  end
end
