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
          let(:agreement) {}
          run_test!
        end
      end
    end
  end
end
