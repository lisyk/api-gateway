# frozen_string_literal: true

require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'

describe 'Wellness Plans API', swagger_doc: 'wellness/v1/swagger.json' do
  path '/api/v1/wellness/contract_applications/agreements/{id}' do
    get 'Generate a new agreement document to complete contract application. Requires contract application ID.' do
      tags 'Agreements'
      produces 'application/pdf'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :id, in: :path, type: :string

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end

        response '200', 'Generate a new agreement PDF' do
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:id) { '1000008890' }
          run_test!
        end

        response '404', 'Document not found' do
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:id) { '123456789' }
          schema '$ref' => '#/components/schemas/not_found_error'
          run_test!
        end
      end

      context 'Using invalid credentials/credentials missing' do
        let(:Authorization) { '' }
        let(:id) { '1000008890' }
        response '403', 'Invalid credentials' do
          schema '$ref' => '#/components/schemas/auth_error'
          run_test!
        end
      end
    end
  end

  path '/api/v1/wellness/contract_applications/agreements/{id}' do
    put 'Upload a signed agreement document' do
      tags 'Agreements'
      produces 'application/json'
      consumes 'multipart/form-data'
      security [bearer_auth: []]
      parameter name: :id,
                in: :path,
                type: :string,
                required: true
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

        response '207', 'Agreement uploads to partner, but cannot be stored in S3 bucket' do
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:id) { '1000013888' }
          file = Rack::Test::UploadedFile.new(
            Rails.root.join('spec/fixtures/files/contract.pdf')
          )
          let(:document) { file }
          before do
            allow_any_instance_of(Wellness::Services::AwsS3Service).to receive(:upload_document).and_raise(StandardError, 'error')
          end
          schema '$ref' => '#/components/schemas/s3_upload_error'
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

  path '/api/v1/wellness/contract_applications/agreements' do
    post 'Upload a signed agreement document to S3 bucket' do
      tags 'Agreements'
      produces 'application/json'
      consumes 'multipart/form-data'
      security [bearer_auth: []]
      parameter name: :id,
                in: :query,
                type: :string,
                required: true
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

        response '200', 'Agreement uploads to S3 bucket' do
          let(:Authorization) { " Authorization: Bearer #{token} " }
          file = Rack::Test::UploadedFile.new(
            Rails.root.join('spec/fixtures/files/contract.pdf')
          )
          let(:document) { file }
          let(:id) { 'test_agreement' }
          schema '$ref' => '#/components/schemas/agreement_upload_response'
          run_test!
        end

        response '422', 'Unprocessable' do
          let(:Authorization) { " Authorization: Bearer #{token} " }
          file = Rack::Test::UploadedFile.new(
            Rails.root.join('spec/fixtures/files/contract.pdf')
          )
          let(:document) { file }
          before do
            allow_any_instance_of(Wellness::Services::AwsS3Service).to receive(:upload_document).and_raise(StandardError, 'error')
          end
          let(:id) { 'test_agreement' }
          schema '$ref' => '#/components/schemas/s3_upload_error'
          run_test!
        end

        response '400', 'Bad request, agreement ID not present' do
          let(:Authorization) { " Authorization: Bearer #{token} " }
          file = Rack::Test::UploadedFile.new(
            Rails.root.join('spec/fixtures/files/contract.pdf')
          )
          let(:document) { file }
          before do
            allow_any_instance_of(Wellness::Services::AwsS3Service).to receive(:upload_document).and_raise(StandardError, 'error')
          end
          let(:id) { nil }
          schema '$ref' => '#/components/schemas/s3_upload_error'
          run_test!
        end
      end

      context 'Using invalid credentials/credentials missing' do
        let(:id) { 'test_agreement' }
        file = Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/files/contract.pdf')
        )
        let(:Authorization) { '' }
        let(:document) { file }
        response '403', 'Invalid credentials' do
          schema '$ref' => '#/components/schemas/auth_error'
          run_test!
        end
      end
    end
  end
end
