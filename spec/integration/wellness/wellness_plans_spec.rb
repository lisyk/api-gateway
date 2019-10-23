require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'

describe 'Wellness Plans' do
  path '/wellness/plans/index' do
    get 'Index' do
      tags 'Wellness Plans'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]

      context 'Using valid credentials' do
        # before(:each) do
        #   #jlb - this works don't change try to use let! syntax instead
        #   @reponse = post :'/api/v1/authentication', params: { user_name: 'test', password: 'test' }
        #   binding.pry
        #   @token = JSON.parse(@response.body)['token']
        # end
          let(:authresponse) { post '/api/v1/authentication', params: { user_name: 'test', password: 'test' } }
          let(:token) {JSON.parse(authresponse.body)['token'] }

        response '200', 'Retrieve List of valid plans' do
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:plans) {}
          binding.pry
          run_test! do |planresponse|
            data = JSON.parse(planresponse.body)
            puts data
          end
        end
      end
    end
  end
end
