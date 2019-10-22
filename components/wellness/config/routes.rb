# frozen_string_literal: true

Wellness::Engine.routes.draw do
  resources :wellness_plans, only: [:index], controller: :plans do
    collection do
      resources :plan_services, only: %i[index] do
      end
    end
  end
end
