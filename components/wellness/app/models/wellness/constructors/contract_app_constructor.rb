# frozen_string_literal: true

module Wellness
  module Constructors
    class ContractAppConstructor < BaseConstructor
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
            update_object(contract)
          end
        else
          update_object(contracts)
        end
        output_results
      end

      def output_results
        contracts.compact.empty? ? { message: ['No contracts matched query'] } : contracts.compact
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

      def update_hash(hash)
        hash.keys.each do |key|
          next if skip_update?(key)

          if needs_complex_mapping?(key)
            hash = complex_field_mapping(hash, key)
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

      def skip_update?(key)
        %w[phone mobile alternate_phone address].include? key
      end

      def field_already_translated?(contract, fields)
        fields.each do |field|
          return true if contract[field].present?
        end
        false
      end

      def update_phone_fields(hash)
        return hash if field_already_translated?(hash, vip_phone_fields)

        new_phone_fields = map_phone_fields(hash)
        new_phone_fields.keys.each do |phone_key|
          hash[phone_key] = new_phone_fields[phone_key]
        end
        delete_old_fields(partner_phone_fields, hash)
      end

      def update_address_fields(hash)
        return hash if field_already_translated?(hash, %w[address])

        hash['address'] = map_address_fields(hash)
        delete_old_fields(partner_address_fields, hash)
      end

      def complex_field_mapping(hash, key)
        if partner_phone_fields.include? key
          update_phone_fields(hash)
        elsif partner_address_fields.include? key
          update_address_fields(hash)
        end
      end

      def partner_phone_fields
        %w[phone1 phone1Type phone2 phone2Type]
      end

      def partner_address_fields
        %w[address1 address2]
      end

      def vip_phone_fields
        %w[phone mobile alternate_phone]
      end

      def needs_complex_mapping?(key)
        %w[phone1 phone1Type phone2 phone2Type address1 address2].include? key
      end
    end
  end
end
