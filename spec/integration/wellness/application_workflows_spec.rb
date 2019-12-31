# frozen_string_literal: true

require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'
require './spec/helpers/application_workflows/workflow_helper.rb'

describe 'Wellness Plans API', swagger_doc: 'wellness/v1/swagger.json' do
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
          workflow_helper = WorkflowHelper.new(:stub_app)
          workflow_helper.post_initial_request
          workflow_helper.put_agreement
          let(:id) { workflow_helper.contract_id }
          let(:final_request_file) { File.read(Rails.root.join('spec/helpers/dummy_docs/application_workflows/put_finalize_application.json')) }
          let(:contract_application) { JSON.parse(final_request_file) }
          schema '$ref' => '#/components/schemas/contract_application_response'
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
