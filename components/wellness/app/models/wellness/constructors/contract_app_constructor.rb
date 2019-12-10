# frozen_string_literal: true

module Wellness
  module Constructors
    class ContractAppConstructor < ResponseLogger
      include Wellness::Services::ContractAppTranslatorService
      include Wellness::Services::ContractAppMapperService

      attr_reader :contracts, :constructor_mapper

      def initialize(origin_contracts, constructor_mapper, _params)
        @contracts = origin_contracts
        @constructor_mapper = constructor_mapper
      end

      def modify
        log_original_response(contracts)
        if contracts.is_a? Array
          contracts.map! do |contract|
            update_contract(contract) if !filter_contract?(contract)
          end
        else
          update_contract(contracts)
        end
        contracts
      end

      def update_contract(contract)
        update_nested_field_names(contract)
        contract
      end

      private

      def ignore_field?(key)
        %w[
          salutation
          middleInitial
          initiatedByProfessionalId
          primaryCareProfessionalId
          initiatedByProfessionalCd
          primaryCareProfessionalCd
        ].include?(key)
      end

      def filter_contract?(contract)
        # TODO: Implement contract filtering
      end

      def update_nested_field_names(object)
        if object.is_a? Hash
          update_hash(object)
        elsif object.is_a? Array
          update_array(object)
        end
      end

      def update_hash(hash)
        hash.keys.each do |key|
          next if skip_translation?(key)

          if %w[phone1 phone1Type phone2 phone2Type].include? key
            next if phone_field_already_translated?(hash)

            new_phone_fields = map_phone_fields(hash)
            new_phone_fields.keys.each do |phone_key|
              hash[phone_key] = new_phone_fields[phone_key]
            end
            %w[phone1 phone1Type phone2 phone2Type].each do |old_field|
              hash.delete old_field
            end
            next
          end
          field_to_replace = constructor_mapper[key]
          value = hash.delete key
          next if field_to_replace.nil? || ignore_field?(key)

          new_key = field_to_replace
          hash[field_to_replace] = translated_value(new_key, value, hash, translate_to: :gateway)
          update_nested_field_names(hash[field_to_replace])
        end
      end

      def update_array(array)
        array.each do |item|
          update_nested_field_names(item)
        end
      end

      def translated_value(new_key, value, contract, translate_to)
        translated_value = translate(new_key, value, contract, translate_to)
        translated_value.nil? ? value : translated_value
      end

      def skip_translation?(key)
        %(phone mobile alternate_phone).include? key
      end

      def phone_field_already_translated?(contract)
        ['phone', 'mobile', 'alternate_phone'].each do |field|
          return true if contract[field].present?
        end
        false
      end
    end
  end
end
