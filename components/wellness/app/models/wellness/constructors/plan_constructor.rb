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
          value = translate(new_key, value) || value
          plan[new_key] = value unless ignore_field?(key)
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

      def translate(key, value)
        return nil if key == 'id'

        if key == 'age_group'
          translate_age_group(value)
        else
          translate_general(key, value)
        end
      end

      def translate_age_group(value)
        age = value % 10
        species = (value / 10).floor
        translation = DbService::AgeGroupTranslation.where('minimum_age < ? AND species = ?',
                                                           age,
                                                           species)
                                                    .order('minimum_age DESC')

        return nil unless translation.any?

        translation.first.age_group
      end

      def translate_general(key, value)
        translation = DbService::Translation.where('concept_name = ? AND partner_value = ?',
                                                   key,
                                                   value.to_s)

        return nil unless translation.any?

        translation.first.gateway_value.to_i
      end
    end
  end
end
