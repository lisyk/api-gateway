# frozen_string_literal: true

require 'swagger_helper'

describe 'API Gateway', swagger_doc: 'api_gateway/v1/swagger.json' do
  path '/api/v1/authentication' do
    post 'Authenticate with API Gateway to access integrations' do
      tags 'Authentication'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :user_name, in: :query, type: :string, required: true
      parameter name: :password, in: :query, type: :string, required: true

      context 'Using valid credentials' do
        response '200', 'Authenticate client to API Gateway' do
          schema '$authentication' => '#/definitions/authentication'
          let(:user_name) { 'test' }
          let(:password) { 'test' }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['token']).not_to be_nil
          end
        end
      end
    end
  end
end
