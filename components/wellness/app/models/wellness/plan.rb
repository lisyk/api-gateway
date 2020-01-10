# frozen_string_literal: true

# this model is responsible for wellness plans ONLY
# no other services handled by this model

module Wellness
  class Plan < Connect
    include Concerns::RequestConcern

    def plans_mapping(params)
      return origin_plans if origin_plans.blank?

      constructor = Constructors::PlanConstructor.new(origin_plans,
                                                      params)
      constructor.modify
    end

    def origin_plans
      api_request
    end
  end
end
