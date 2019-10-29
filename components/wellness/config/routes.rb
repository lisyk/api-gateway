# frozen_string_literal: true

Wellness::Engine.routes.draw do
  resources :plans, only: [:index]
  resources :contract_applications, only: %i[index show create]
  resources :agreements, only: [:show]
  resources :plan_services, only: [:show, :index]
end
