# frozen_string_literal: true

module Wellness
  module Constructors
    class PlanConstructor < ResponseLogger
      include Wellness::Services::PlanTranslatorService

      attr_reader :plans, :constructor_mapper

      def initialize(plans, constructor_mapper)
        @plans = plans
        @constructor_mapper = constructor_mapper
      end

      def modify
        log_original_response(plans)
        if plans.is_a? Array
          plans.each do |plan|
            update_plan(plan)
          end
        else
          update_plan(plans)
        end
      end

      def update_plan(plan)
        plan.keys.each do |key|
          field_to_replace = constructor_mapper[key]
          value = plan.delete key
          next if field_to_replace.nil? || ignore_field?(key)

          new_key = field_to_replace
          translated_value = translate(new_key, value) || value
          plan[new_key] = translated_value
        end
        plan
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
    end
  end
end
