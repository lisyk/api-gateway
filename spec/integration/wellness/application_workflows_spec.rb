# frozen_string_literal: true

require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'

describe 'Wellness Plans API', swagger_doc: 'wellness/v1/swagger.json' do
  path '/api/v1/wellness/initiate_application' do
    post 'Initiate a new application and retrieve agreement document' do
      tags 'Contract Application Workflow'
      produces 'application/pdf'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :contract_application,
                in: :body,
                schema: {
                  '$ref' => '#/components/schemas/vip_initiate_application'
                }
      request_body_json schema: {
        '$ref' => '#/components/schemas/vip_initiate_application'
      }

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end
        let(:Authorization) { " Authorization: Bearer #{token} " }

        response '200', 'Initiate a new application and retrieve agreement document' do
          let(:file) { File.read(Rails.root.join('spec/helpers/dummy_docs/application_workflows/post_initiate_application.json')) }
          let(:payload) { JSON.parse(file) }
          let(:contract_application) do
            payload['pet_id'] = SecureRandom.uuid
            payload['owner_id'] = (rand * 10**16).floor.to_s
            payload
          end
          run_test!
        end

        response '400', 'Bad request' do
          let(:file) { File.read(Rails.root.join('spec/helpers/dummy_docs/application_workflows/post_initiate_application.json')) }
          let(:payload) { JSON.parse(file) }
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
end
