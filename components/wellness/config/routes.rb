# frozen_string_literal: true

require 'open_api/rswag/ui/engine'
require 'open_api/rswag/api/engine'

Wellness::Engine.routes.draw do
  mount OpenApi::Rswag::Api::Engine => '/api-docs'
  mount OpenApi::Rswag::Ui::Engine => '/api-docs'
  get 'plans/index'
end
