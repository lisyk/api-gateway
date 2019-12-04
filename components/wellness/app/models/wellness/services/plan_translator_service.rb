# frozen_string_literal: true

module Wellness
  module Services
    module PlanTranslatorService
      def translate(key, value)
        return nil if key == 'id'

        if key == 'age_group'
          translate_age_group(value)
        elsif translatable_concepts.include? key
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

      private

      def translatable_concepts
        @translatable_concepts ||= DbService::Translation.all.pluck('concept_name').uniq
      end
    end
  end
end
