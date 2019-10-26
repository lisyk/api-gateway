# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class PlansController < ::Api::V1::ApiController
    before_action :user_authorized?

    def index
      #TODO needs to be updated from DEMO to PROD
      @wellness_plans ||= fetch_plans if demo_client_ready
      if @wellness_plans.present?
        render json: { plans: @wellness_plans }
      else
        render json: { errors: ['Wellness plans are not available.'] }, status: :not_found
      end
    end

    private

    def fetch_plans
      plans_service = WellnessPlans.new(controller_name, action_name)
      plans_service.plans_mapping
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
