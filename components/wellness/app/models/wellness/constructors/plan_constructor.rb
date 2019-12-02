# frozen_string_literal: true

module Wellness
  module Constructors
    class PlanConstructor < ResponseLogger
      attr_reader :plans, :constructor_mapper

      def initialize(plans, constructor_mapper, params)
        @plans = plans
        @constructor_mapper = constructor_mapper
        @clinic_location_id = params[:clinic_location_id]
        @is_sellable = params[:is_sellable]
        @species = params[:species]
        @age = params[:age]
      end

      def filter_plan?(plan)
        [
          filter_clinic_location(plan),
          filter_sellable(plan),
          filter_species(plan),
          filter_age(plan)
        ].any?(true)
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
        plans.compact.empty? ? { message: ['No plans matched query'] } : plans.compact
      end

      def update_plan(plan)
        plan.keys.each do |key|
          next if !constructor_mapper.plan_mapping(key)

          field_to_replace = constructor_mapper.plan_mapping(key).first
          value = plan.delete key
          next unless field_to_replace

          new_key = field_to_replace.vip_field.field_name
          plan[new_key] = value unless ignore_field?(key)
        end
        plan
      end

      def filter_clinic_location(plan)
        return false if @clinic_location_id.nil?

        return true if plan['location']['externalLocationCd'] != @clinic_location_id

        false
      end

      def filter_sellable(plan)
        return false if @is_sellable.nil?

        is_sellable = @is_sellable.downcase == 'true'

        if is_sellable
          !plan_active?(plan) || expired_or_early?(plan)
        else
          plan_active?(plan) && !expired_or_early?(plan)
        end
      end

      def filter_species(plan)
        return false if @species.nil?

        species_codes = @species.split(',')
        species_codes.each do |code|
          return false if plan['species'].present? && plan['species'] == code.to_i
        end
        true
      end

      def filter_age(plan)
        return false if @age.nil?

        age_in_years = convert_age
        group = age_groups.select { |_k, v| v <= age_in_years }.max.first.to_i

        return true if plan['ageGroup'].present? && plan['ageGroup'] % 10 != group

        false
      end

      private

      def expired_or_early?(plan)
        expired = DateTime.current > plan['planExpirationDate'].to_datetime
        early = DateTime.current < plan['planEffectiveDate'].to_datetime

        expired || early
      end

      def plan_active?(plan)
        plan['planStatus'] == 'A'
      end

      def age_groups
        # TODO: Determine actual age groups
        {
          '1' => 0,
          '2' => 1,
          '3' => 3,
          '4' => 7
        }
      end

      def convert_age
        return @age if @age.is_a? Numeric

        if @age.include?(':')
          ((DateTime.current - @age.to_datetime) / 364).floor
        else
          parse_age_string
        end
      end

      def parse_age_string
        age_years = @age.scan(/\d+(?=[Yy])/).first.to_i || 0
        age_months = @age.scan(/\d+(?=[Mm])/).first.to_i || 0

        [@age.to_i, age_years + (age_months / 12).floor].max
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
