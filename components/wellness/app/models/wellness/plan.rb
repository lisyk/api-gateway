# frozen_string_literal: true
# this model is responsible for wellness plans ONLY
# no other services handled by this model

module Wellness
  class Plan < Connect
    include Concerns::RequestConcern

    def plans_mapping
      constructor = Constructors::PlanConstructor.new(origin_plans, constructor_mapper)
      constructor.modify
    end

    def constructor_mapper
      {
          'species' => species_modifier_rule,
          'age_group' => age_group_modifier_rule,
          'sex' => sex_modofier_rule 
      }
    end

    def origin_plans
      api_request
    end

    #custom attribute modifier rules
    # # TODO implememt rule that modify VCP species (1,2...) to VIP
    def species_modifier_rule
      'species'
    end

    #custom attribute modifier rules
    # TODO implememt rule that modify VCP age group to VIP
    def age_group_modifier_rule
      nil
    end

    #custom attribute modifier rules
    def sex_modofier_rule
      nil
    end
  end
end
