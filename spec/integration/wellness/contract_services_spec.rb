# frozen_string_literal: true

require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'

describe 'Wellness Plans API', swagger_doc: 'wellness/v1/swagger.json' do
  path '/api/v1/wellness/contract_services' do
    get 'List of available contract services.' do
      tags 'Available Contract Services'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :contractId, type: :string

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end

        response '200', 'List of contract services' do
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:plan_services) {}
          schema '$ref' => '#/components/schemas/contract_service_list'
          run_test!
        end
      end
    end
  end
end
