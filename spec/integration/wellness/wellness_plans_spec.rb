# frozen_string_literal: true

require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'
require 'dotenv'
Dotenv.load('.env.test.local')

describe 'Wellness Plans API', swagger_doc: 'wellness/v1/swagger.json' do
  path '/api/v1/wellness/plans' do
    get 'Retrieve a list of available wellness plans.' do
      tags 'Wellness Plans'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end

        response '200', 'Retrieve list of valid plans' do
          schema '$ref' => '#/components/schemas/plan'
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:plans) {}
          run_test!
        end
      end
    end
  end

  path '/api/v1/wellness/plans/{id}' do
    get 'Retrieve a single plan by ID' do
      tags 'Wellness Plans'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :id, in: :path, type: :string

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end

        response '200', 'Retrieve plan' do
          schema '$ref' => '#/components/schemas/plan'
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:id) { '5428455' }
          let(:agreement) {}
          run_test!
        end
      end
    end
  end
end
