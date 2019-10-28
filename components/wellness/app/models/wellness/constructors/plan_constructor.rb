module Wellness
  module Constructors
    class PlanConstructor
      attr_reader :plans, :constructor_mapper

      def initialize(plans, constructor_mapper)
        @plans = plans
        @constructor_mapper = constructor_mapper
      end

      def modify
        plans.each do |plan|
          plan.merge! construct_attributes(plan)
        end
        plans
      end

      def construct_attributes(plan)
        vip_attr = {'vip_mapped_attributes' => {}}
        constructor_mapper.each do |key, value|
          vip_attr['vip_mapped_attributes'][key] = plan[value]
        end
        vip_attr
      end
    end
  end
end