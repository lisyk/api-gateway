# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class PlansController < Wellness::ApplicationController
    before_action :user_authorized?

    def index
      @wellness_plans ||= demo_client_ready ? client_request : test_plans
      render json: { plans: @wellness_plans }
    end

    private

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
