# frozen_string_literal: true

require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'

describe 'Wellness Plans API', swagger_doc: 'wellness/v1/swagger.json' do
  path '/api/v1/wellness/contract_applications/{id}' do
    get 'Show a single contract given an ID' do
      tags 'Contracts'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :id,
                in: :path,
                type: :string

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end
        let(:Authorization) { " Authorization: Bearer #{token} " }
        let(:id) { '1000008889' }

        response '200', 'Retrieve a single contract' do
          run_test!
        end

        response '404', 'Not found' do
          let(:id) { 'fake_id' }
          schema '$ref' => '#/components/schemas/not_found_error'
          run_test!
        end
      end

      context 'Using invalid credentials/credentials missing' do
        let(:Authorization) { '' }
        let(:id) { '1000008889' }

        response '403', 'Invalid credentials' do
          schema '$ref' => '#/components/schemas/auth_error'
          run_test!
        end
      end
    end
  end
end
