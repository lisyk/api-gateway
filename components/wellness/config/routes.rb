# frozen_string_literal: true

Wellness::Engine.routes.draw do
  resources :plans, only: [:index]
  resources :plan_services, only: %i[index]
  resources :contract_applications, only: %i[index show] do
    collection do
      resources :agreements, only: [:show]
    end
  end
end
