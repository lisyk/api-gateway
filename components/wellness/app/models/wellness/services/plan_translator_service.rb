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

        convert_data_type(translation, translate_to)
      end

      private

      def translatable_concepts
        @translatable_concepts ||= DbService::Translation.all.pluck('concept_name').uniq
      end

      def data_types
        {
          'string' => :to_s,
          'integer' => :to_i,
          'number' => :to_f,
          'float' => :to_f
        }
      end

      def convert_data_type(translation, translate_to)
        value_field = (translate_to.to_s + '_value').to_sym
        value = translation.first.send(value_field)
        type_field = (translate_to.to_s + '_value_type').to_sym
        data_type = translation.first.send(type_field)

        if data_type != 'boolean'
          value.send(data_types[data_type])
        elsif data_type == 'boolean'
          value == 'true'
        end
      end
    end
  end
end
