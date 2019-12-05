# frozen_string_literal: true

module Wellness
  module Services
    module PlanTranslatorService
      def translate(key, value, translate_to: :gateway)
        return nil if key == 'id'

        if key == 'age_group'
          translate_age_group(value)
        elsif translatable_concepts.include? key
          translate_general(key, value, translate_to)
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

      def translate_general(key, value, translate_to)
        value_type = translate_to == :gateway ? 'partner_value' : 'gateway_value'
        translation = DbService::Translation.where("concept_name = ? AND #{value_type} = ?",
                                                   key,
                                                   value.to_s)

        return nil unless translation.any?

        if translate_to == :partner
          translation.first.partner_value
        elsif translate_to == :gateway
          translation.first.gateway_value
        end
      end

      private

      def translatable_concepts
        @translatable_concepts ||= DbService::Translation.all.pluck('concept_name').uniq
      end
    end
  end
end
