# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class PlansController < ::Api::V1::ApiController
    before_action :user_authorized?

    def index
      @wellness_plans ||= demo_client_ready ? fetch_plans : test_plans
      render json: { plans: @wellness_plans }
    end

    private

    def fetch_plans
      WellnessPlans.new.api_request(controller_name, action_name)
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

    def user_authorized?
      return unless @current_user != 'authorized'

      render json: { errors: ['You are not authorized'] }, status: :forbidden
    end

    def demo_client_ready
      Settings.api.vcp_wellness.demo_client_ready
    end
  end
end
