# frozen_string_literal: true

require 'rails_helper'
require(File.expand_path('../../app/controllers/api/v1/api_controller'))
require(File.expand_path('../../components/wellness/spec/helpers/faraday_mock.rb'))

module Wellness
  RSpec.describe ContractsController, type: :controller do
    routes { Wellness::Engine.routes }
    let(:file_path) { File.expand_path('../../helpers/dummy_docs/contracts/contracts_sample.json', __dir__) }
    let(:contracts_sample) { File.read(file_path) }
    let(:contracts) { JSON.parse contracts_sample }

    describe '#index' do
      context 'authenticated' do
        before :each do
          controller.instance_variable_set(:@current_user, 'authorized')
          allow(controller).to receive(:authenticate!).and_return true
          stub_const('Settings', route_settings)
        end
        describe 'contracts service available' do
          before :each do
            allow(controller).to receive(:contracts).and_return contracts
            get :index
          end
          it 'returns 200 response' do
            expect(response).to have_http_status(200)
          end
          it 'returns correct content type' do
            expect(response.content_type).to include 'application/json'
          end
          it 'assigns contract' do
            expect(assigns(:contracts)).not_to be_nil
          end
          it 'returns a list of contracts' do
            expect(assigns(:contracts)).to be_a Array
          end
        end
        describe 'contracts service unavailable' do
          before :each do
            allow(controller).to receive(:contracts).and_return nil
            get :index
          end
          it 'returns 404 response' do
            expect(response).to have_http_status(404)
          end
          it 'does not assign contracts' do
            expect(assigns(:contracts)).to be_nil
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
        it "doesn't assign contracts" do
          expect(assigns(:contracts)).to be_nil
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
        describe 'contract service available' do
          before :each do
            allow(controller).to receive(:contracts).and_return contracts.first
            get :show, params: { id: '1000008889' }
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
          it 'returns one contract' do
            expect(assigns(:contract)).not_to be_a Array
          end
        end
        describe 'pet UUID conversion' do
          before :each do
            allow(controller).to receive(:contracts).and_return contracts.first
            allow(controller).to receive(:contract_app_id_client).and_return FaradayMock.new('123456789')
          end
          it 'converts pet UUID' do
            get :show, params: { id: 'd525ffb5-d627-41f9-a317-86a205a9e130' }
            expect(controller.params).to include :id
            expect(controller.params[:id]). to eq '123456789'
          end
          it 'ignores contract ID' do
            get :show, params: { id: '123456789' }
            expect(controller.params).to include :id
            expect(controller.params[:id]). to eq '123456789'
          end
          it 'ignores non UUID' do
            get :show, params: { id: 'bad_UUID' }
            expect(controller.params).to include :id
            expect(controller.params[:id]). to eq 'bad_UUID'
          end
        end
        describe 'contract service unavailable' do
          before :each do
            allow(controller).to receive(:contracts).and_return nil
            get :show, params: { id: '1000008889' }
          end
          it 'returns 404 response' do
            expect(response).to have_http_status(404)
          end
          it 'does not assign contract' do
            expect(assigns(:contract)).to be_nil
          end
        end
      end
      context 'unauthenticated' do
        before do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, nil)
          get :show, params: { id: '1000008889' }
        end
        it 'returns error message to the client' do
          expect(JSON.parse(response.body)['errors']).to include 'You are not authorized'
        end
        it 'returns 403 error message' do
          expect(response).to have_http_status(403)
        end
        it "doesn't assign contract" do
          expect(assigns(:contract)).to be_nil
        end
      end
    end
  end
end
