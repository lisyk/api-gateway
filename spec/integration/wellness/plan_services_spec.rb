# frozen_string_literal: true

require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'

describe 'Wellness Plans API', swagger_doc: 'wellness/v1/swagger.json' do
  path '/api/v1/wellness/plan_services' do
    get 'Retrieve a list of available plan services.' do
      tags 'Plan Services'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end

        response '200', 'Retrieve list of plan services' do
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:plan_services) {}
          schema '$ref' => '#/components/schemas/service_list'
          run_test!
        end
      end
    end
  end

  path '/api/v1/wellness/plan_services/{id}' do
    get 'Retrieve a single plan service by ID' do
      tags 'Plan Services'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :id, in: :path, type: :string

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end

        response '200', 'Retrieve plan service' do
          schema '$ref' => '#/components/schemas/service'
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:id) { '5428456' }
          let(:agreement) {}
          run_test!
        end
      end
    end
  end
end
