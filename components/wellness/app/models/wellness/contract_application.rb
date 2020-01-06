# frozen_string_literal: true

module Wellness
  class ContractApplication < Connect
    include Concerns::RequestConcern

    def contract_app_mapping(params, contracts = origin_contracts)
      return contracts if contracts.blank?

      constructor = Constructors::ContractAppConstructor.new(contracts,
                                                             constructor_mapper,
                                                             params)
      constructor.modify
    end

    def constructor_mapper
      file_name = 'contract_applications_response_mapper.json'
      file_path = '../../../lib/mappers/contract_applications/' + file_name
      mapper_file = File.expand_path(file_path, __dir__)
      JSON.parse(File.read(mapper_file))
    end

    def origin_contracts
      api_request
    end
  end
end
