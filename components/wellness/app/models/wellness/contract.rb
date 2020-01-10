# frozen_string_literal: true

module Wellness
  class Contract < Connect
    include Concerns::RequestConcern

    def contract_mapping(params)
      return origin_contracts if origin_contracts.blank?

      constructor = Constructors::ContractConstructor.new(origin_contracts,
                                                          params)
      constructor.modify
    end

    def origin_contracts
      api_request
    end
  end
end
