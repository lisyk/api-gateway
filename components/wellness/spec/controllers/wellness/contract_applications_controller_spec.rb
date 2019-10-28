# frozen_string_literal: true

require 'rails_helper'
require(File.expand_path('../../app/controllers/api/v1/api_controller'))

module Wellness
  RSpec.describe ContractApplicationsController, type: :controller do
    routes { Wellness::Engine.routes }
    let(:file_path) { File.expand_path('../../helpers/dummy_docs/contract_applications/contract_applications_sample.json', __dir__) }
    let(:contract_apps_sample) { File.read(file_path) }
    let(:contract_apps) { JSON.parse contract_apps_sample }

    describe '#index' do
      context 'authenticated' do
        before :each do
          controller.instance_variable_set(:@current_user, 'authorized')
          allow(controller).to receive(:authenticate!).and_return true
          stub_const('Settings', route_settings)
        end
        describe 'agreement service available' do
          before :each do
            allow(controller).to receive(:contract_apps).and_return contract_apps
            get :index
          end
          it 'returns 200 response' do
            expect(response).to have_http_status(200)
          end
          it 'returns correct content type' do
            expect(response.content_type).to include 'application/json'
          end
          it 'assigns applications' do
            expect(assigns(:applications)).not_to be_nil
          end
        end
        describe 'agreement service unavailable' do
          before :each do
            allow(controller).to receive(:contract_apps).and_return nil
            get :index
          end
          it 'returns 404 error message' do
            expect(response).to have_http_status(404)
          end
          it 'returns correct error message' do
            expect(JSON.parse(response.body)['errors']).to include 'Contract applications agreements are not available.'
          end
          it 'does not assign applications' do
            expect(assigns(:applications)).to be_nil
          end
        end
      end
      context 'unauthenticated' do
        before do
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
        it "doesn't assign applications" do
          expect(assigns(:applications)).to be_nil
        end
      end
    end
    describe '#show' do
      context 'authenticated' do
        before :each do
          controller.instance_variable_set(:@current_user, 'authorized')
          allow(controller).to receive(:authenticate!).and_return true
          stub_const('Settings', route_settings)
        end
        describe 'agreement service available' do
          before :each do
            allow(controller).to receive(:contract_apps).and_return contract_apps.first
            get :show, params: { id: '1000008890' }
          end
          it 'returns 200 response' do
            expect(response).to have_http_status(200)
          end
          it 'returns correct content type' do
            expect(response.content_type).to include 'application/json'
          end
          it 'assigns applications' do
            expect(assigns(:application)).not_to be_nil
          end
          it 'returns one application' do
            expect(assigns(:application)).not_to be_a Array
          end
        end
        describe 'agreement service unavailable' do
          before :each do
            allow(controller).to receive(:contract_apps).and_return nil
            get :show, params: { id: '1000008890' }
          end
          it 'returns 404 response' do
            expect(response).to have_http_status(404)
          end
          it 'does not assign application' do
            expect(assigns(:application)).to be_nil
          end
        end
      end
      context 'unauthenticated' do
        before do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, nil)
          get :show, params: { id: '1000008890' }
        end
        it 'returns error message to the client' do
          expect(JSON.parse(response.body)['errors']).to include 'You are not authorized'
        end
        it 'returns 403 error message' do
          expect(response).to have_http_status(403)
        end
        it "doesn't assign wellness_plans" do
          expect(assigns(:application)).to be_nil
        end
      end
    end

<<<<<<< HEAD
    describe 'POST #create' do
      let(:application_sample_file) { File.read(File.expand_path('../../helpers/dummy_docs/applications/origin_application_sample.json', __dir__)) }
      let(:application) { JSON.parse application_sample_file }

      context 'authenticated' do
        before :each do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, 'authorized')
        end
        describe 'appiclation available' do
          before do
            allow(controller).to receive(:client_post_request).and_return application
          end
          it 'returns application' do
            post :create
            expect(response).to have_http_status(200)
            expect(assigns(:application)).not_to be_nil
          end
        end
      end
      context 'not authenticated' do
        before do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, nil)
        end
        it 'sends error message to the client' do
          post :create
          expect(response).to have_http_status(403)
          expect(JSON.parse(response.body)['errors']).to include 'You are not authorized'
        end
        it "doesn't assign wellness_plans" do
          expect(assigns(:application)).to be_nil
=======
    describe '#create' do
      context 'correct credentials' do
        before :each do
          controller.instance_variable_set(:@current_user, 'authorized')
          allow(controller).to receive(:authenticate!).and_return true
          stub_const('Settings', settings)
        end
        it 'responds json' do
          VCR.use_cassette('vcp_contract_applications_create_auth') do
            get :create
          end
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end

        it 'returns a single application' do
          VCR.use_cassette('vcp_contract_applications_create_auth') do
            get :create
          end
          expect(JSON.parse(response.body).is_a?(Array)).to eql false
        end
      end

      context 'incorrect credentials' do
        before { allow(controller).to receive(:authenticate!).and_return false }
        it 'sends error message to the client' do
          request.headers.merge!('Authorization' => '')
          VCR.use_cassette('vcp_contract_applications_create_no_auth') do
            get :create
          end
          expect(response).to have_http_status(403)
>>>>>>> Added post to contract application endpoint
        end
      end
    end
  end
end
