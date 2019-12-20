# frozen_string_literal: true

module Wellness
  class ContractsController < ApplicationController
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

    def translate(request)
      RequestTranslation.new(request, controller_name).translate_request.to_json
    end
  end
end
