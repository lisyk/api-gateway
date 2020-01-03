# frozen_string_literal: true

require 'rails_helper'
require 'json-schema'
require(File.expand_path('../../app/controllers/api/v1/api_controller'))

module Wellness
  RSpec.describe ApplicationWorkflowsController, type: :controller do
    routes { Wellness::Engine.routes }

    describe 'post #create' do
      let(:contract) { File.read(File.expand_path('../../helpers/dummy_docs/application_workflows/origin_workflows_sample.json', __dir__)) }
      let(:returned_contract) { File.read(File.expand_path('../../helpers/dummy_docs/contract_applications/post_contract_applications_sample.json', __dir__)) }
      let(:contract_document) { Base64.strict_encode64(File.read(File.expand_path('../../helpers/dummy_docs/contracts/contract.pdf', __dir__))) }
      context 'authenticated' do
        before :each do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, 'authorized')
          stub_const('Settings', route_settings)
          token = {
            'access_token' => 'access_token',
            'expires_in' => 3600
          }.to_json
          stub_request(:post, 'https://demo.vcp.vet/cwa/api/login')
            .to_return(status: 200, body: token, headers: {})
          stub_request(:get, 'https://demo.vcp.vet/cwa/api/contractApplicationAgreement/1000008890')
            .to_return(status: 200, body: contract_document, headers: {})
        end
        describe 'partner service available' do
          before :each do
            allow_any_instance_of(ApplicationWorkflow).to receive(:partner_initialization_request)
            allow(controller).to receive(:validate_request).and_return nil
            allow(controller).to receive(:post_contract).and_return returned_contract
            allow(controller).to receive(:valid_submission?).and_return true
            allow(controller).to receive(:retain_id_link).and_return nil
            allow(controller).to receive(:contract_app_id).and_return '1000008890'
            post :create
          end
          it 'returns 200 response' do
            expect(response).to have_http_status(200)
          end
          it 'returns correct content type' do
            expect(response.content_type).to include 'application/json'
          end
          it 'assigns contract_document' do
            expect(assigns(:contract_document)).not_to be_nil
          end
        end
        describe 'invalid request' do
          before do
            request_schema_path = '../../../../swagger/request_schemas/vcp/application_workflows.json#application_workflows_create'
            allow(controller).to receive(:schema)
              .and_return('$ref' => Rails.root.join(request_schema_path).to_s)
            post :create, {}
          end
          it 'returns 400 error message' do
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)['malformed_request']).to be_present
          end
        end
        describe 'unable to create contract app' do
          before do
            allow_any_instance_of(ApplicationWorkflow).to receive(:partner_initialization_request)
            allow(controller).to receive(:validate_request).and_return nil
            allow(controller).to receive(:post_contract).and_return nil
            post :create
          end
          it 'returns 422 error or missing response' do
            expect(response).to have_http_status(422)
          end
          it 'returns 400 error for bad request' do
            allow(controller).to receive(:post_contract).and_return('errors' => true)
            post :create
            expect(response).to have_http_status(400)
          end
          it 'returns correct error message' do
            expect(JSON.parse(response.body)['errors']).to be_present
          end
        end
        describe 'unable to retrieve agreement' do
          before :each do
            allow_any_instance_of(ApplicationWorkflow).to receive(:partner_initialization_request)
            allow(controller).to receive(:validate_request).and_return nil
            allow(controller).to receive(:post_contract).and_return returned_contract
            allow(controller).to receive(:valid_submission?).and_return true
            allow(controller).to receive(:retain_id_link)
            allow(controller).to receive(:contract_app_id).and_return 'fake_id'
            stub_request(:get, 'https://demo.vcp.vet/cwa/api/contractApplicationAgreement/fake_id')
              .to_return(status: 404, body: {}.to_json, headers: {})
            post :create
          end
          it 'returns 404 for not found' do
            expect(response).to have_http_status(404)
          end
          it 'returns correct error message' do
            expect(JSON.parse(response.body)['errors']).to be_present
            expect(JSON.parse(response.body)['errors']).to include 'Agreement not found.'
          end
        end
      end
      context 'not authenticated' do
        before :each do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, nil)
          post :create
        end
        it 'returns error message to the client' do
          expect(JSON.parse(response.body)['errors']).to include 'You are not authorized'
        end
        it 'returns 403 error message' do
          expect(response).to have_http_status(403)
        end
      end
    end

    describe 'PUT #update' do
      let(:contract) { File.read(File.expand_path('../../helpers/dummy_docs/application_workflows/origin_workflows_sample.json', __dir__)) }
      context 'authenticated' do
        before :each do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, 'authorized')
          stub_const('Settings', route_settings)
        end
        describe 'partner service available' do
          before :each do
            allow_any_instance_of(ApplicationWorkflow).to receive(:partner_finalization_request)
            allow(controller).to receive(:validate_request).and_return nil
            allow(controller).to receive(:put_apps).and_return JSON.parse(contract)
            put :update, params: { id: '1000015105' }
          end
          it 'returns 200 response' do
            expect(response).to have_http_status(200)
          end
          it 'returns correct content type' do
            expect(response.content_type).to include 'application/json'
          end
          it 'assigns contract' do
            expect(assigns(:contract)).not_to be_nil
          end
        end
        describe 'not finalized' do
          before :each do
            allow_any_instance_of(ApplicationWorkflow).to receive(:partner_finalization_request)
            allow(controller).to receive(:validate_request).and_return nil
            allow(controller).to receive(:put_apps).and_return nil
            put :update, params: { id: '1000015105' }
          end
          it 'returns 422 for unprocessable' do
            expect(response).to have_http_status(422)
          end
          it 'returns correct error message' do
            expect(JSON.parse(response.body)['errors']).to be_present
          end
        end
        describe 'bad request' do
          before :each do
            allow(controller).to receive(:json_schema_path).and_return Rails.root.join('../../../../swagger/request_schemas/vcp/').to_s
            put :update, params: { id: '1000015105' }
          end
          it 'returns 400 for bad request' do
            expect(response).to have_http_status(400)
          end
          it 'returns correct error message' do
            expect(JSON.parse(response.body)['malformed_request']).to be_present
          end
        end
      end
      context 'not authenticated' do
        before :each do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, nil)
          put :update, params: { id: '1000015105' }
        end
        it 'returns error message to the client' do
          expect(JSON.parse(response.body)['errors']).to include 'You are not authorized'
        end
        it 'returns 403 error message' do
          expect(response).to have_http_status(403)
        end
      end
    end
  end
end
