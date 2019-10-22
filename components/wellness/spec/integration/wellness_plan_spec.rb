require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'

describe 'Wellness Plans' do
    path '/api/v1/wellness_plans' do
    
      get '#Index' do
        tags "Wellness Plans"
        produces 'application/json'
        consumes 'application/json'
        security [bearer_auth: []]

          context 'Using valid credentials' do
            before(:each) do
              @params = {params: {user_name: "test", password: "test"}}
              @reponse = post '/api/v1/authentication', @params
              @body = response.body
              @token = JSON.parse(@response.body)["token"]
            end

            response '200', "Retrieve List of valid plans" do 
              let(:Authorization) {"Authorization: Bearer {@token}"}
              let(:wellness_plans) {}
              run_test! 
            end
      end
    end
  end
end