# frozen_string_literal: true

require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'
require './spec/helpers/application_workflows/workflow_helper.rb'

describe 'Wellness Plans API', swagger_doc: 'wellness/v1/swagger.json' do
  path '/api/v1/wellness/initiate_application' do
    post 'Initiate a new application and retrieve agreement document' do
      tags 'Contract Application Workflow'
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

        response '200', 'Initiate a new application and retrieve agreement document' do
          let(:contract_application) { WorkflowHelper.new(:stub_app).rswag_initial_request_body }
          schema '$ref' => '#/components/schemas/initialize_application_response'
          run_test!
        end

        response '400', 'Bad request' do
          let(:payload) { WorkflowHelper.new(:stub_app).rswag_initial_request_body }
          let(:contract_application) do
            payload['pet_id'] = nil
            payload
          end
          schema '$ref' => '#/components/schemas/malformed_request_error'
          run_test!
        end
      end
    end
  end

  path '/api/v1/wellness/submit_agreement/{id}' do
    put 'Upload a signed agreement document' do
      tags 'Contract Application Workflow'
      produces 'application/json'
      consumes 'multipart/form-data'
      security [bearer_auth: []]
      parameter name: :id, in: :path, type: :string
      parameter name: :document,
                in: :formData,
                type: :file,
                required: true
      request_body_multipart schema: {
        '$ref' => '#/components/schemas/agreement'
      }

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end

        response '200', 'Upload signed PDF document' do
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:id) { '1000013888' }
          file = Rack::Test::UploadedFile.new(
            Rails.root.join('spec/fixtures/files/contract.pdf')
          )
          let(:document) { file }
          schema '$ref' => '#/components/schemas/agreement_upload_response'
          run_test!
        end

        response '404', 'Document not found' do
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:id) { '123456789' }
          file = Rack::Test::UploadedFile.new(
            Rails.root.join('spec/fixtures/files/contract.pdf')
          )
          let(:document) { file }
          schema '$ref' => '#/components/schemas/not_found_error'
          run_test!
        end
      end

      context 'Using invalid credentials/credentials missing' do
        file = Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/files/contract.pdf')
        )
        let(:Authorization) { '' }
        let(:id) { '1000008890' }
        let(:document) { file }
        response '403', 'Invalid credentials' do
          schema '$ref' => '#/components/schemas/auth_error'
          run_test!
        end
      end
    end
  end

  path '/api/v1/wellness/finalize_application/{id}' do
    put 'Finalize a contract application after submitting a signed agreement document' do
      tags 'Contract Application Workflow'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :id,
                in: :path,
                type: :string
      parameter name: :contract_application,
                in: :body,
                schema: {
                  '$ref' => '#/components/schemas/vip_finalize_application'
                }
      request_body_json schema: {
        '$ref' => '#/components/schemas/vip_finalize_application'
      }

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end
        let(:Authorization) { " Authorization: Bearer #{token} " }

        response '200', 'Finalize a contract application' do
          schema '$ref' => '#/components/schemas/contract_application_response'
          before do
            @workflow_helper = WorkflowHelper.new(:stub_app)
            initial_request_response = @workflow_helper.post_initial_request
            agreement_response = @workflow_helper.put_agreement
            expect(initial_request_response).to have_http_status(200)
            expect(initial_request_response.body['id']).to be_present
            expect(agreement_response).to have_http_status(200)
          end
          let(:id) { @workflow_helper.contract_id }
          let(:final_request_file) { File.read(Rails.root.join('spec/helpers/dummy_docs/application_workflows/put_finalize_application.json')) }
          let(:contract_application) { JSON.parse(final_request_file) }
          run_test!
        end

        response '400', 'Bad request' do
          let(:file) { File.read(Rails.root.join('spec/helpers/dummy_docs/application_workflows/put_finalize_application.json')) }
          let(:id) { '1000015105' }
          let(:contract_application) { {} }
          schema '$ref' => '#/components/schemas/malformed_request_error'
          run_test!
        end

        response '422', 'Unprocessable' do
          let(:file) { File.read(Rails.root.join('spec/helpers/dummy_docs/application_workflows/put_finalize_application.json')) }
          let(:id) { '1000015105' }
          let(:contract_application) { JSON.parse(file) }
          schema '$ref' => '#/components/schemas/not_completed_error'
          run_test!
        end
      end
    end
  end
end
