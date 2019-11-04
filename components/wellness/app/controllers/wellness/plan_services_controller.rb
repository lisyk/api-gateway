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
      plans_service = Plan.new(controller_name, action_name)
      plans_service.plans_mapping
    end

    # test hardcoded data. TODO clean up
    def test_services
      { plans: [
        {
          "id": '123',
          "name": 'service1'
        },
        {
          "id": '1234',
          "name": 'service2'
        }
      ] }
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
