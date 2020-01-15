# frozen_string_literal: true

module Wellness
  module Constructors
    class PlanConstructor < BaseConstructor
      include Wellness::Services::PlanTranslatorService
      include Wellness::Services::PlanFilterService

      attr_reader :plans

      def initialize(plans, params)
        @plans = plans
        @clinic_location_id = params[:clinic_location_id]
        @is_sellable = params[:is_sellable]
        @species = params[:species]
        @age = params[:age]
      end

      def modify
        log_original_response(plans)
        if plans.is_a? Array
          plans.map! do |plan|
            update_object(plan) if !filter_plan?(plan)
          end
        else
          update_object(plans)
        end
        output_results(plans, 'plans')
      end

      private

      def ignore_field?(key)
        %w[
          renewalPlan
          planType
          productSubType
          locationId
          planEffectiveDate
          planExpirationDate
          planStatus
        ].include?(key)
      end

      def filter_plan?(plan)
        [
          filter_clinic_location(plan),
          filter_sellable(plan),
          filter_species(plan),
          filter_age(plan)
        ].any?(true)
      end
    end
  end
end
