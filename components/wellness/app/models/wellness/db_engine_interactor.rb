# frozen_string_literal: true

module Wellness
  class DbEngineInteractor
    class << self
      def call(pet_id:, contract_app_id:)
        pet_contract = find_contract(pet_id)
        if pet_contract.present?
          update_record(pet_contract, contract_app_id)
        else
          create_record(contract_app_id, pet_id)
        end
      end

      def find_contract(pet_id)
        DbService::PetContract.find_by(pet_id: pet_id)
      end

      def update_record(pet_contract, contract_app_id)
        pet_contract.update(contract_app_id: contract_app_id)
      end

      def create_record(contract_app_id, pet_id)
        DbService::PetContract.create!(contract_app_id: contract_app_id, pet_id: pet_id)
      end
    end
  end
end
