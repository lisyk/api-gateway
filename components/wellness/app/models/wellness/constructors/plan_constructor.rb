# frozen_string_literal: true

module Wellness
  module Constructors
    class PlanConstructor < ResponseLogger
      include Wellness::Services::PlanTranslatorService
      include Wellness::Services::PlanFilterService

      attr_reader :plans, :constructor_mapper

      def initialize(plans, constructor_mapper, params)
        @plans = plans
        @constructor_mapper = constructor_mapper
        @clinic_location_id = params[:clinic_location_id]
        @is_sellable = params[:is_sellable]
        @species = params[:species]
        @age = params[:age]
      end

      def modify
        log_original_response(plans)

        if plans.is_a? Array
          plans.map! do |plan|
            update_plan(plan) if !filter_plan?(plan)
          end
        else
          update_plan(plans)
        end

        output_results
      end

      def update_plan(plan)
        update_nested_field_names(plan)
        plan
      end

      def output_results
        plans.compact.empty? ? { message: ['No plans matched query'] } : plans.compact
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

      def update_nested_field_names(object)
        if object.is_a? Hash
          object.keys.each do |key|
            field_to_replace = constructor_mapper[key]
            value = object.delete key
            next if field_to_replace.nil? || ignore_field?(key)

            object[field_to_replace] = value
            update_nested_field_names(object[field_to_replace])
          end
        elsif object.is_a? Array
          object.each do |item|
            update_nested_field_names(item)
          end
        end
      end
    end
  end
end
