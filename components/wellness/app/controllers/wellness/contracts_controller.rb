# frozen_string_literal: true

module Wellness
  class ContractsController < ApplicationController
    include Services::PetUuidService

    before_action :convert_pet_uuid, only: %i[show]

    def index
      @contracts ||= contracts(contract_params)
      if @contracts.present?
        render json: @contracts
      else
        render json: { errors: ['Contracts are not available.'] },
               status: :not_found
      end
    end

    def show
      @contract ||= contracts(contract_params)
      if @contract.present?
        render json: @contract
      else
        render json: { errors: ['Contract could not be found.'] },
               status: :not_found
      end
    end

    private

    def contracts(params = {})
      contract = Contract.new(controller_name, action_name, params)
      contract.contract_mapping(params)
    end

    def contract_params
      params.except(:format).permit(:id)
    end
  end
end
