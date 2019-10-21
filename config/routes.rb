# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Wellness::Engine, at: '/'
  namespace :api do
    namespace :v1 do
      post :authentication, to: 'authentication#create'
    end
  end
end
