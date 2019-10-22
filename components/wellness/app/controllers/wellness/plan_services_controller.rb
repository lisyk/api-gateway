# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class PlanServicesController < ::Api::V1::ApiController
    def index
      if @current_user == 'authorized'
        demo_client_ready = Settings.api.vcp_wellness.demo_client_ready
        @plan_services ||= demo_client_ready ? fetch_services : test_services
        render json: { services: @plan_services }
      else
        render json: { errors: ['You are not authorized'] }, status: :forbidden
      end
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
  end
end
