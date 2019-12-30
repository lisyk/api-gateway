# frozen_string_literal: true

require 'rails_helper'
require 'json-schema'
require(File.expand_path('../../app/controllers/api/v1/api_controller'))

module Wellness
  RSpec.describe ApplicationWorkflowsController, type: :controller do
    routes { Wellness::Engine.routes }

    let(:contract) { File.read(File.expand_path('../../helpers/dummy_docs/application_workflows/origin_workflows_sample.json', __dir__)) }

    describe 'PUT #update' do
      context 'authenticated' do
        before :each do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, 'authorized')
          stub_const('Settings', route_settings)
        end
        describe 'partner service available' do
          before :each do
            allow(controller).to receive(:validate_request).and_return nil
            allow(controller).to receive(:build_partner_finalization_request)
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
            allow(controller).to receive(:validate_request).and_return nil
            allow(controller).to receive(:build_partner_finalization_request)
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
