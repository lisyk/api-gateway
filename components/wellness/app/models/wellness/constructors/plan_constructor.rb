# frozen_string_literal: true

module Wellness
  module Constructors
    class PlanConstructor < ResponseLogger
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
          field_to_replace = constructor_mapper.plan_mapping(key).first
          value = plan.delete key
          next unless field_to_replace

          new_key = field_to_replace.vip_field.field_name
          plan[new_key] = value unless ignore_field?(key)
        end
        plan
      end

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
