# frozen_string_literal: true

require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'

describe 'Wellness Plans API', swagger_doc: 'wellness/v1/swagger.json' do
  path '/api/v1/wellness/contract_services' do
    get 'List of available contract services.' do
      tags 'Contract Services'
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

    post 'Consume contract services.' do
      tags 'Contract Services'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :serviceConsumptionList,
                in: :body,
                schema: {
                    '$ref' => '#/components/schemas/consume_contract_services'
                }
      request_body_json schema: {
          '$ref' => '#/components/schemas/consume_contract_services'
      }

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end
        let(:service_payload) do
          {
              "owner_id": "1000",
              "external_consumption_id": "16600",
              "external_invoice_date": "2019-02-18T18:20:12Z",
              "external_invoice_number": "8877",
              "clinic_location_id": "010265",
              "pet_id": "1333",
              "external_service_cd": "36600",
              "external_service_name": "Joo",
              "external_service_type": "vaccine",
              "posting_date": "2019-02-18T18:20:12Z",
              "service_date": "2019-02-18T18:20:12Z",
              "service_delivered_by_cd": "4433",
              "service_delivered_by_name": "JJJ",
              "invoiced_price": 17.5,
              "discount_amt": 0
          }
        end

        response '200', 'Consume contract services' do
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:serviceConsumptionList) { service_payload }
          run_test!
        end
      end

      context 'Using invalid credentials/credentials missing' do
        let(:Authorization) { '' }

        response '403', 'Invalid credentials' do
          schema '$ref' => '#/components/schemas/auth_error'
          run_test!
        end
      end
    end
  end
end
