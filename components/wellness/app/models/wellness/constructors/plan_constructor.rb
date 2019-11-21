# frozen_string_literal: true

module Wellness
  module Constructors
    class PlanConstructor
      attr_reader :plans, :constructor_mapper

      def initialize(plans, constructor_mapper)
        @plans = plans
        @constructor_mapper = constructor_mapper
      end

      def modify
        plans.each do |plan|
          update_plan(plan)
        end
      end

      def update_plan(plan)
        plan.keys.each do |key|
          field_to_replace = constructor_mapper.plan_mapping(key).first
          next unless field_to_replace

          new_key = field_to_replace.vip_field.field_name
          plan[new_key] = plan.delete key
        end
        plan
      end
    end
  end
end
