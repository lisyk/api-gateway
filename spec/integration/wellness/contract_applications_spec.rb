# frozen_string_literal: true

require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'

describe 'Wellness Plans API', swagger_doc: 'wellness/v1/swagger.json' do
  path '/api/v1/wellness/contract_applications' do
    post 'Create a new contract application' do
      tags 'Contract Applications'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :contract_application,
                in: :body,
                schema: {
                  '$ref' => '#/components/schemas/contract_application_request'
                }
      request_body_json schema: {
        '$ref' => '#/components/schemas/contract_application_request'
      }

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end
        let(:Authorization) { " Authorization: Bearer #{token} " }
        let(:file) { File.read(Rails.root.join('spec/helpers/dummy_docs/contract_applications/post_contract_applications.json')) }
        let(:contract_application) { JSON.parse(file) }

        response '200', 'Create a new contract application' do
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:pet_id) { SecureRandom.uuid }
          let(:contract_application) do
            {
              clinic_location_id: 5_426_720,
              plan_code: 5_428_455,
              owner_first_name: 'Harry',
              owner_last_name: 'Potter',
              address: '4 Privet Drive',
              city: 'Morino Valley',
              state: 'CA',
              zip: '92551',
              country: 'US',
              mobile: '1234567890',
              phone: '0987654321',
              email: 'randomemail694201@random.com',
              owner_id: '1123121321',
              pet_id: 'd525ffb5-d6a7-41f9-a317-86a205a9e130',
              pet_name: 'Cece',
              age: '1Y 2M',
              gender: '',
              card_name: 'Visa',
              payment_name: 'Olivia Wright',
              expiration_month: 1,
              expiration_year: 2099,
              card_number: '1111',
              initial_payment_option: 12,
              optional_plan_services: []
            }
          end
          schema '$ref' => '#/components/schemas/contract_application_response'
          run_test!
        end

        response '400', 'Bad request' do
          let(:file) { File.read(Rails.root.join('spec/helpers/dummy_docs/contract_applications/post_contract_applications_malformed.json')) }
          let(:contract_application) { JSON.parse(file) }
          schema '$ref' => '#/components/schemas/malformed_request_error'
          run_test!
        end
      end
    end
  end

  path '/api/v1/wellness/contract_applications' do
    get 'Retrieve a list of existing contract applications' do
      tags 'Contract Applications'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end
        let(:Authorization) { " Authorization: Bearer #{token} " }

        response '200', 'Retrieve list of contract applications' do
          schema '$ref' => '#/components/schemas/contract_application_response_list'
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

  path '/api/v1/wellness/contract_applications/{id}' do
    get 'Show a single contract application given an ID' do
      tags 'Contract Applications'
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
        let(:id) { '1000013427' }
        let(:contract_application) {}

        response '200', 'Retrieve list of contract applications' do
          schema '$ref' => '#/components/schemas/application'
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:id) { '1000013427' }
          let(:contract_application) {}
          schema '$ref' => '#/components/schemas/contract_application_response'
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
        let(:id) { '1000013427' }

        response '403', 'Invalid credentials' do
          schema '$ref' => '#/components/schemas/auth_error'
          run_test!
        end
      end
    end
  end

  path '/api/v1/wellness/contract_applications/{id}' do
    put 'Update an existing contract application. Used to modify fields and complete the application. Contract applications with a status of 5 are converted to finalized contracts.' do
      tags 'Contract Applications'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :contract_application,
                in: :body,
                schema: {
                  '$ref' => '#/components/schemas/contract_application_request'
                }
      parameter name: :id,
                in: :path,
                type: :string
      request_body_json schema: {
        '$ref' => '#/components/schemas/contract_application_request'
      }

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end
        let(:Authorization) { " Authorization: Bearer #{token} " }
        let(:id) { '1000014069' }
        let(:file) { File.read(Rails.root.join('spec/helpers/dummy_docs/contract_applications/put_contract_applications.json')) }
        let(:application_payload) { JSON.parse(file) }
        let(:contract_application) do
          application_payload['first_billing_date'] = DateTime.current
          application_payload
        end

        response '200', 'Update or finalize an existing contract application' do
          schema '$ref' => '#/components/schemas/contract_application_response'
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:contract_application) do
            {
              clinic_location_id: 5_426_720,
              plan_code: 5_428_455,
              owner_first_name: 'Harry',
              owner_last_name: 'Potter',
              address: '4 Privet Drive',
              city: 'Morino Valley',
              state: 'CA',
              zip: '92551',
              country: 'US',
              mobile: '1234567890',
              phone: '0987654321',
              email: 'randomemail694201@random.com',
              owner_id: '1123121321',
              pet_id: 'd525ffb5-d6a7-41f9-a317-86a205a9e130',
              pet_name: 'Cece',
              age: '1Y 2M',
              gender: '',
              card_name: 'Visa',
              payment_name: 'Olivia Wright',
              expiration_month: 1,
              expiration_year: 2099,
              card_number: '1111',
              initial_payment_option: 12,
              optional_plan_services: [],
              first_billing_date: DateTime.current
            }
          end
          run_test!
        end

        response '422', 'Unprocessable Entity' do
          let(:file) { File.read(Rails.root.join('spec/helpers/dummy_docs/contract_applications/put_contract_applications_malformed.json')) }
          let(:contract_application) { JSON.parse(file) }
          let(:id) { '1000015090' }
          schema '$ref' => '#/components/schemas/malformed_request_error'
          run_test!
        end
      end

      context 'Using invalid credentials/credentials missing' do
        let(:Authorization) { '' }
        let(:id) { '1000013302' }

        response '403', 'Invalid credentials' do
          schema '$ref' => '#/components/schemas/auth_error'
          run_test!
        end
      end
    end
  end
end
