# frozen_string_literal: true

module Wellness
  class ContractApplication < Connect
    include Concerns::RequestConcern

    def contract_app_mapping(params, contracts = origin_contracts)
      return contracts if contracts.blank?

      constructor = Constructors::ContractAppConstructor.new(contracts,
                                                             params)
      constructor.modify
    end

    def origin_contracts
      api_request
    end
  end
end
