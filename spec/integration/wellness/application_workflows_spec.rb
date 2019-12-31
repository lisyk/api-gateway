# frozen_string_literal: true

require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'

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
          # let(:initial_request_file) { File.read(Rails.root.join('spec/helpers/dummy_docs/contract_applications/post_contract_applications.json')) }
          # let(:payload) { JSON.parse(initial_request_file) }
          # let(:contract_app_request_body) do
          #   payload['externalMemberCd'] = SecureRandom.uuid
          #   payload['externalClientCd'] = SecureRandom.uuid
          #   payload['email'] = dummy_email
          #   payload['portalUsername'] = payload['email']
          #   payload
          # end
          # let(:application) do
          #   post '/api/v1/wellness/contract_applications', params: { body: contract_app_request_body }
          #   response
          # end
          # let(:agreement) do
          #   put "/api/v1/wellness/contract_applications/agreements/#{id}"
          # end
          let(:id) { @id }
          let(:final_request_file) { File.read(Rails.root.join('spec/helpers/dummy_docs/application_workflows/put_finalize_application.json')) }
          let(:contract_application) { JSON.parse(final_request_file) }
          schema '$ref' => '#/components/schemas/vip_contract_application'
          run_test!
        end

        response '400', 'Bad request' do
          let(:file) { File.read(Rails.root.join('spec/helpers/dummy_docs/application_workflows/put_finalize_application.json')) }
          let(:id) { '1000015105' }
          let(:payload) { JSON.parse(file) }
          let(:contract_application) do
            payload.delete 'initial_payment_option'
            payload
          end
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

def dummy_email
  first_name = random_string
  last_name = random_string
  provider = random_string
  domain = %w[com net edu org gov].sample
  first_name + '.' + last_name + '@' + provider + '.' + domain
end

def random_string
  SecureRandom.hex[0..9]
end

def initial_request_body
  initial_request_file = File.read(Rails.root.join('spec/helpers/dummy_docs/contract_applications/post_contract_applications.json'))
  payload = JSON.parse(initial_request_file)
  payload['externalMemberCd'] = SecureRandom.uuid
  payload['externalClientCd'] = SecureRandom.uuid
  payload['email'] = dummy_email
  payload['portalUsername'] = payload['email']
  payload.to_json
end

def post_initial_request
  post '/api/v1/wellness/contract_applications', 
    params: initial_request_body, 
    headers: { 
      Authorization: "Bearer #{token}", 
      'Content-Type'.to_sym => 'application/json' 
    }
  response_body = JSON.parse(response.body)
  @id = response_body['id']
  response_body
end

def agreement
  Rack::Test::UploadedFile.new( Rails.root.join('spec/fixtures/files/contract.pdf') )
end

def put_agreement
  put "/api/v1/wellness/contract_applications/agreements/#{@id}",
    params: agreement,
    headers: {
      Authorization: "Bearer #{token}",
      'Content-Type'.to_sym => 'application/pdf'
    }
  JSON.parse(response.body)
end

def token
  post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
  JSON.parse(response.body)['token']
end