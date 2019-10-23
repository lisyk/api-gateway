# frozen_string_literal: true

require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'

describe 'Wellness Plans API', swagger_doc: 'wellness/v1/swagger.json' do
  path '/wellness/plans/index' do
    get 'Index' do
      tags 'Wellness Plans'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]

      context 'Using valid credentials' do
        before(:all) do
          @authreponse = post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          @authtoken = JSON.parse(@response.body)['token']
        end

        response '200', 'Retrieve List of valid plans' do
          #schema '$plan' => '#/definitions/plan'
          let(:Authorization) { " Authorization: Bearer #{@authtoken} " }
          let(:plans) {}
          run_test!
        end
      end
    end
  end
end
