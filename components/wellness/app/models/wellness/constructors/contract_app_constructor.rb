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
        output_results(contracts, 'contracts')
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

      def skip_update?(key)
        %w[phone mobile alternate_phone address].include? key
      end

      def field_already_translated?(contract, fields)
        fields.each do |field|
          return true if contract[field].present?
        end
        false
      end

      def complex_field_mapping(hash, key)
        if partner_phone_fields.include? key
          update_complex_fields(hash, vip_phone_fields, partner_phone_fields, :map_phone_fields)
        elsif partner_address_fields.include? key
          update_complex_fields(hash, %w[address], partner_address_fields, :map_address_fields)
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
