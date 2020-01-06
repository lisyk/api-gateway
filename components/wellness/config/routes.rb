# frozen_string_literal: true

Wellness::Engine.routes.draw do
  resources :plans, only: [:index, :show]
  resources :plan_services, only: %i[index show]
  resources :contract_applications, only: %i[index show create update] do
    collection do
      resources :agreements, only: %i[show update]
    end
  end
  resources :contracts, only: %i[index show]
  post '/initiate_application', to: 'application_workflows#create'
  put '/submit_agreement/:id', to: 'application_workflows#submit_agreement'
  put '/finalize_application/:id', to: 'application_workflows#update'
  resources :contract_services, only: :index
end
