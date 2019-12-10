# frozen_string_literal: true

module Wellness
  module Constructors
    class ContractAppConstructor < ResponseLogger
      attr_reader :contracts, :constructor_mapper

      def initialize(origin_contracts, constructor_mapper, _params)
        @contracts = origin_contracts
        @constructor_mapper = constructor_mapper
      end

      def modify
        log_original_response(contracts)
        if contracts.is_a? Array
          contracts.each do |contract|
            update_contract(contract)
          end
        else
          update_contract(contracts)
        end
        contracts
      end

      def update_contract(contract)
        contract.keys.each do |key|
          field_to_replace = constructor_mapper[key]
          contract.delete key if ignore_field?(key)
          next unless field_to_replace.present? || ignore_field?(key)

          value = contract.delete key
          new_key = field_to_replace
          contract[new_key] = value
        end
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
    end
  end
end
