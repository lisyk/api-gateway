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
          get :index
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end

        it 'returns a list of applications' do
          get :index
          expect(JSON.parse(response.body)['applications'].is_a?(Array)).to eql true
        end
      end

      context 'incorrect credentials' do
        before { allow(controller).to receive(:authenticate!).and_return false }
        it 'sends error message to the client' do
          request.headers.merge!('Authorization' => '')
          get :index
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
          get :show, params: { id: '1000008890' }
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end

        it 'returns a single application' do
          get :show, params: { id: '1000008890' }
          expect(JSON.parse(response.body).is_a?(Array)).to eql false
        end
      end

      context 'incorrect credentials' do
        before { allow(controller).to receive(:authenticate!).and_return false }
        it 'sends error message to the client' do
          request.headers.merge!('Authorization' => '')
          get :show, params: { id: '1000008890' }
          expect(response).to have_http_status(403)
        end
      end
    end
  end
end
