# frozen_string_literal: true

module Wellness
  class Contract < Connect
    include Concerns::RequestConcern

    def contract_mapping(params)
      return origin_contracts if origin_contracts.blank?

      constructor = Constructors::ContractConstructor.new(origin_contracts,
                                                          constructor_mapper,
                                                          params)
      constructor.modify
    end

    def constructor_mapper
      file_name = 'contract_response_mapper.json'
      file_path = '../../../lib/mappers/contracts/' + file_name
      mapper_file = File.expand_path(file_path, __dir__)
      JSON.parse(File.read(mapper_file))
    end

    def origin_contracts
      api_request
    end
  end
end
