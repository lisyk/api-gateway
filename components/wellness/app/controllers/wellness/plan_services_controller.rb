# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class PlanServicesController < ::Api::V1::ApiController
    before_action :user_authorized?

    def index
        @plan_services ||= demo_client_ready ? fetch_services : test_services
        render json: { services: @plan_services }
    end

    private

    def fetch_services
      WellnessPlans.new.api_request(controller_name, action_name)
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
