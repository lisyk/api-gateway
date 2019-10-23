# frozen_string_literal: true

Rails.application.routes.draw do
  mount OpenApi::Rswag::Ui::Engine => '/vip-api-docs'
  mount OpenApi::Rswag::Api::Engine => '/vip-api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Wellness::Engine, at: '/wellness', as: 'wellness'
  namespace :api do
    namespace :v1 do
      post :authentication, to: 'authentication#create'
    end
  end
end
