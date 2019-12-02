# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class PlansController < Wellness::ApplicationController
    def index
      @wellness_plans ||= fetch_plans(plan_params)
      if @wellness_plans.present?
        render json: { plans: @wellness_plans }
      else
        render json: { errors: ['Wellness plans are not available.'] }, status: :not_found
      end
    end

    def show
      @plan ||= fetch_plans(plan_params)
      if @plan.present?
        render json: { plan: @plan }
      else
        render json: { errors: ['Wellness plan unavailable.'] }, status: :not_found
      end
    end

    private

    def fetch_plans(params)
      plans = Plan.new(controller_name, action_name, params)
      plans.plans_mapping(params)
    end

    def plan_params
      params.except(:format).permit(:id, :clinic_location_id, :is_sellable, :species, :age)
    end
  end
end
