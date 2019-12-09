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
      parameter name: :clinic_location_id, in: :query, type: :string, required: false, description: 'VIP clinic ID'
      parameter name: :is_sellable, in: :query, type: :boolean, required: false, description: 'Plan is active and within date range'
      parameter name: :species, in: :query, type: :string, required: false, description: 'VIP species code'
      parameter name: :age,
                in: :query,
                type: :string,
                required: false,
                description: 'Age in years. Accepts integer years, YYMM formatted strings (i.e. "3Y1M"), and datetime strings (i.e. "2016-11-22T21:45:58+00:00")'

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end

        response '200', 'Retrieve List of valid plans' do
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:plans) {}
          schema '$ref' => '#/components/schemas/plan_list'
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

      parameter name: :clinic_location_id, in: :query, type: :string, required: false, description: 'VIP clinic ID'
      parameter name: :is_sellable, in: :query, type: :boolean, required: false, description: 'Plan is active and within date range'
      parameter name: :species, in: :query, type: :string, required: false, description: 'VIP species code'
      parameter name: :age,
                in: :query,
                type: :string,
                required: false,
                description: 'Age in years. Accepts integer years, YYMM formatted strings (i.e. "3Y1M"), and datetime strings (i.e. "2016-11-22T21:45:58+00:00")'

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end

        response '200', 'Retrieve plan' do
          schema '$ref' => '#/components/schemas/plan'
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:id) { '5428455' }
          let(:plan) {}
          run_test!
        end
      end
    end
  end
end
