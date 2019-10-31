# frozen_string_literal: true

require 'rails_helper'
require(File.expand_path('../../app/controllers/api/v1/api_controller'))

module Wellness
  RSpec.describe PlanServicesController, type: :controller do
    routes { Wellness::Engine.routes }
    let(:plans_sample_file) { File.read(File.expand_path('../../helpers/dummy_docs/plan_services/origin_services_sample.json', __dir__)) }
    let(:plan_services) { JSON.parse plans_sample_file }

    describe 'GET #index' do
      context 'authenticated' do
        before :each do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, 'authorized')
          stub_const('Settings', route_settings)
        end
        describe 'Services available' do
          before :each do
            allow(controller).to receive(:fetch_services).and_return plan_services
            get :index
          end
          it 'returns 200 response' do
            expect(response).to have_http_status(200)
          end
          it 'returns correct content type' do
            expect(response.content_type).to include 'application/json'
          end
          it 'assigns plan services' do
            expect(assigns(:plan_services)).not_to be_nil
          end
        end
        describe 'Services not available' do
          before do
            allow(controller).to receive(:fetch_services).and_return nil
            get :index
          end
          it 'returns 404 error message' do
            expect(response).to have_http_status(404)
          end
          it 'returns correct error message' do
            expect(JSON.parse(response.body)['errors']).to include 'Plan services are not available.'
          end
          it 'does not assign plan_services' do
            expect(assigns(:plan_services)).to be_nil
          end
        end
      end
      context 'not authenticated' do
        before :each do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, nil)
          get :index
        end
        it 'returns error message to the client' do
          expect(JSON.parse(response.body)['errors']).to include 'You are not authorized'
        end
        it 'returns 403 error message' do
          expect(response).to have_http_status(403)
        end
        it "doesn't assign plan_services" do
          expect(assigns(:plan_services)).to be_nil
        end
      end
    end
  end
end
