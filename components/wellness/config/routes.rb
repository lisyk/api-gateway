# frozen_string_literal: true

Wellness::Engine.routes.draw do
  mount OpenApi::Rswag::Api::Engine => '/api-docs'
  mount OpenApi::Rswag::Ui::Engine => '/api-docs'
  get 'plans/index'
end
