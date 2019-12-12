# frozen_string_literal: true

module Wellness
  class ContractApplication < Connect
    include Concerns::RequestConcern

    def contract_app_mapping(params)
      return origin_contracts if origin_contracts.blank?

      constructor = Constructors::ContractAppConstructor.new(origin_contracts,
                                                             constructor_mapper,
                                                             params)
      constructor.modify
    end

    def constructor_mapper
      file_path = '../../../lib/mappers/contract_applications/contract_applications_mapper.json'
      mapper_file = File.expand_path(file_path, __dir__)
      JSON.parse(File.read(mapper_file))
    end

    def origin_contracts
      api_request
    end
  end
end
