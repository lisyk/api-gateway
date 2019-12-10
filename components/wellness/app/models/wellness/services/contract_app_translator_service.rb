# frozen_string_literal: true

module Wellness
  module Services
    module ContractAppTranslatorService
      def translate(key, value, _contract, translate_to: :gateway)
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
        translations = DbService::Translation.where('concept_name = ?', key)

        return nil unless translations.any?

        translations.each do |translation|
          if translation.translation_value[value_type] == value
            return translation.translation_value[translate_to.to_s + '_value']
          end
        end
        nil
      end

      private

      def translatable_concepts
        @translatable_concepts ||= DbService::Translation.all.pluck('concept_name').uniq
      end
    end
  end
end
