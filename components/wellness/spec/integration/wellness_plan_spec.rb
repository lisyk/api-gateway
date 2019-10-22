# frozen_string_literal: true

require 'swagger_helper'
require 'rails_helper'
require 'wellness/application_controller'
require 'jwt'
require(File.expand_path('../../app/controllers/api/v1/api_controller'))
require(File.expand_path('../../app/models/jwt_auth_token'))

describe 'Wellness Plans' do
  path '/wellness/plans/index' do
    get 'index' do
      tags 'Wellness Plans'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]
      context 'Using valid credentials' do
        response '200', 'Retrieve List of valid plans' do
          let(:Authorization) { "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX3JvbGUiOiJ2aXBfYWRtaW4iLCJleHAiOjE1NzQ0NDE0MTd9.JDCIZHHsrUOAS5U60hihX0XpTHxtn1UI5Fz4Til6yI0" }
          let(:index) {}
          run_test!
        end
      end
    end
  end
end
