# frozen_string_literal: true

module Wellness
  module Services
    module PlanFilterService
      include PlanTranslatorService

      def filter_clinic_location(plan)
        return false if @clinic_location_id.nil?

        plan['location']['externalLocationCd'] != @clinic_location_id
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
          translated_code = translate('species_id', code, translate_to: :partner) || code
          return false if plan['species'].present? && plan['species'] == translated_code.to_i
        end
        true
      end

      def filter_age(plan)
        return false if @age.nil?

        age_in_years = convert_age
        group = age_groups.select { |_k, v| v <= age_in_years }.max.first.to_i
        group_mismatched = plan['ageGroup'].present? && plan['ageGroup'] % 10 != group
        return true if group.positive? && group_mismatched

        false
      end

      def age_groups
        age_groups = {}
        @age_group_translations ||= DbService::AgeGroupTranslation.all
        @age_group_translations.each do |translation|
          age_groups[translation.age_group] = translation.minimum_age.to_i
        end
        age_groups.empty? ? { '-1': -1 } : age_groups
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
    end
  end
end
