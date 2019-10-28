# frozen_string_literal: true

Wellness::Engine.routes.draw do
  resources :plans, only: [:index] do
    collection do
      resources :contract_applications, only: %i[index show] do
        collection do
          resources :agreements, only: [:show, :update]
        end
      end
    end
  end
end
