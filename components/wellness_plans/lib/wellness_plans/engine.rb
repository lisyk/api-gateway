module WellnessPlans
  class Engine < ::Rails::Engine
    isolate_namespace WellnessPlans
    config.generators.api_only = true
  end
end
