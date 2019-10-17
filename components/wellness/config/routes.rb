# frozen_string_literal: true

Wellness::Engine.routes.draw do
  get 'plans/index'
  resources :wellness_plans, only: [:index] do
    collection do
      resources :contract_applications, only: %i[index show] do
        collection do
          resources :agreements, only: [:show]
        end
      end
    end
  end
end
