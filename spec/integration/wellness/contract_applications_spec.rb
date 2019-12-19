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
                  '$ref' => '#/components/schemas/vip_contract_application'
                }
      request_body_json schema: {
        '$ref' => '#/components/schemas/vip_contract_application'
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
          schema '$ref' => '#/components/schemas/vip_contract_application'
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
          schema '$ref' => '#/components/schemas/vip_contract_application_list'
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
          schema '$ref' => '#/components/schemas/vip_contract_application'
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
                  '$ref' => '#/components/schemas/vip_contract_application'
                }
      parameter name: :id,
                in: :path,
                type: :string
      request_body_json schema: {
        '$ref' => '#/components/schemas/vip_contract_application'
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
          schema '$ref' => '#/components/schemas/vip_contract_application'
          run_test!
        end

        response '400', 'Bad request' do
          let(:file) { File.read(Rails.root.join('spec/helpers/dummy_docs/contract_applications/put_contract_applications_malformed.json')) }
          let(:contract_application) { JSON.parse(file) }
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
