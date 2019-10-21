# frozen_string_literal: true

Wellness::Engine.routes.draw do
mount Wellness::Engine::OpenApi::Rswag::Ui::Engine => '/api-docs'
 # mount OpenApi::Rswag::Api::Engine => '/wellness/api-docs'
  get 'plans/index'
end
