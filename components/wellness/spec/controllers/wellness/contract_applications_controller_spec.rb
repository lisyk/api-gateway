# frozen_string_literal: true

require 'rails_helper'
require(File.expand_path('../../app/controllers/api/v1/api_controller'))

module Wellness
  RSpec.describe ContractApplicationsController, type: :controller do
    routes { Wellness::Engine.routes }
    let(:settings_yaml) { YAML.safe_load(File.read(File.expand_path('../../../../config/settings/test.yml', Rails.root))) }
    let(:settings_convert) { settings_yaml.to_json }
    let(:settings) { JSON.parse(settings_convert, object_class: OpenStruct) }

    describe '#index' do
      context 'correct credentials' do
        before :each do
          controller.instance_variable_set(:@current_user, 'authorized')
          allow(controller).to receive(:authenticate!).and_return true
          stub_const('Settings', settings)
        end
        it 'responds json' do
          VCR.use_cassette('vcp_contract_applications_auth') do
            get :index
          end
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end

        it 'returns a list of applications' do
          VCR.use_cassette('vcp_contract_applications_auth') do
            get :index
          end
          expect(JSON.parse(response.body).is_a?(Array)).to eql true
        end
      end

      context 'incorrect credentials' do
        before { allow(controller).to receive(:authenticate!).and_return false }
        it 'sends error message to the client' do
          request.headers.merge!('Authorization' => '')
          VCR.use_cassette('vcp_contract_applications_no_auth') do
            get :index
          end
          expect(response).to have_http_status(403)
        end
      end
    end

    describe '#show' do
      context 'correct credentials' do
        before :each do
          controller.instance_variable_set(:@current_user, 'authorized')
          allow(controller).to receive(:authenticate!).and_return true
          stub_const('Settings', settings)
        end
        it 'responds json' do
          VCR.use_cassette('vcp_contract_applications_show_auth') do
            get :show, params: { id: '1000008890' }
          end
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end

        it 'returns a single application' do
          VCR.use_cassette('vcp_contract_applications_show_auth') do
            get :show, params: { id: '1000008890' }
          end
          expect(JSON.parse(response.body).is_a?(Array)).to eql false
        end
      end

      context 'incorrect credentials' do
        before { allow(controller).to receive(:authenticate!).and_return false }
        it 'sends error message to the client' do
          request.headers.merge!('Authorization' => '')
          VCR.use_cassette('vcp_contract_applications_show_no_auth') do
            get :show, params: { id: '1000008890' }
          end
          expect(response).to have_http_status(403)
        end
      end
    end

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
        end
      end
    end
  end
end
