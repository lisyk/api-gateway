# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class PlansController < Wellness::ApplicationController
    def index
      # TODO: needs to be updated from DEMO to PROD
      @wellness_plans ||= fetch_plans if demo_client_ready
      if @wellness_plans.present?
        render json: { plans: @wellness_plans }
      else
        render json: { errors: ['Wellness plans are not available.'] }, status: :not_found
      end
    end

    private

    def fetch_plans
      plans_service = Plan.new(controller_name, action_name)
      plans_service.plans_mapping
    end
  end
end
