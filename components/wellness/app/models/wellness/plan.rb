# frozen_string_literal: true

# this model is responsible for wellness plans ONLY
# no other services handled by this model

module Wellness
  class Plan < Connect
    include Concerns::RequestConcern

    def plans_mapping
      return origin_plans if origin_plans.blank?

      constructor = Constructors::PlanConstructor.new(origin_plans, constructor_mapper)
      constructor.modify
    end

    def constructor_mapper
      mapper_file = File.expand_path('../../../lib/mappers/vcp_vip_fields.json', __dir__)
      JSON.parse(File.read(mapper_file))
    end

    def origin_plans
      api_request
    end
  end
end
