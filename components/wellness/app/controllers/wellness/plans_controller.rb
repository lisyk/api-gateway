# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class PlansController < ::Api::V1::ApiController
    before_action :test_plans

    def index
      if @current_user == 'authorized'
        demo_client_ready = Settings.api.vcp_wellness.demo_client_ready
        @wellness_plans ||= demo_client_ready ? fetch_plans : test_plans
        render json: { plans: @wellness_plans }
      else
        render json: { errors: ['You are not authorized'] }, status: :forbidden
      end
    end

    private

    def fetch_plans
      WellnessPlans.new.api_request(action_name)
    end

    # test hardcoded data. TODO clean up
    def test_plans
      { plans: [
        {
          "id": '123',
          "name": 'plan',
          "age": '13'
        },
        {
          "id": '1234',
          "name": 'plan2',
          "age": '2'
        }
      ] }
    end
  end
end
