WellnessPlans::Engine.routes.draw do
  get 'plans', to: "vcp_wellness_plans#index"
end
