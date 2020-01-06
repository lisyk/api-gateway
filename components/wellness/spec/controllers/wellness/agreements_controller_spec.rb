# frozen_string_literal: true

require 'rails_helper'
require(File.expand_path('../../app/controllers/api/v1/api_controller'))
require 'redis'

module Wellness
  RSpec.describe AgreementsController, type: :controller do
    routes { Wellness::Engine.routes }
    let(:agreement) { double 'agreement' }

    describe '#show' do
      context 'authenticated' do
        before :each do
          controller.instance_variable_set(:@current_user, 'authorized')
          allow(controller).to receive(:authenticate!).and_return true
          stub_const('Settings', route_settings)
        end
        describe 'agreements service available' do
          before :each do
            allow(controller).to receive(:fetch_agreement).and_return agreement
            allow(agreement).to receive(:body) { 'file' }
            get :show, params: { id: '1000008890' }
          end
          it 'returns 200 response' do
            expect(response).to have_http_status 200
          end
          it 'assigns agreement' do
            expect(assigns(:agreement)).not_to be_nil
          end
        end
        describe 'agreements service unavailable' do
          before :each do
            allow(controller).to receive(:fetch_agreement).and_return nil
            get :show, params: { id: '1000008890' }
          end
          it 'returns 404 response' do
            expect(response).to have_http_status(404)
            expect(JSON.parse(response.body)['errors']).to include 'Agreement unavailable.'
          end
          it 'assigns agreement' do
            expect(assigns(:agreement)).to be_nil
          end
        end
      end
      context 'unauthenticated' do
        before do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, nil)
          get :show, params: { id: '1000008890' }
        end
        it 'sends error message to the client' do
          expect(response).to have_http_status(403)
          expect(JSON.parse(response.body)['errors']).to include 'You are not authorized'
        end
        it "doesn't assign agreement" do
          expect(assigns(:agreement)).to be_nil
        end
      end
    end

    describe 'PUT #update' do
      let(:put_agreement_sample_file) { File.read(File.expand_path('../../helpers/dummy_docs/agreements/contract.pdf', __dir__)) }
      let(:put_agreement) { put_agreement_sample_file }

      context 'authenticated' do
        before :each do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, 'authorized')
        end
        describe 'agreement available' do
          before do
            allow(controller).to receive(:put_agreement).and_return('Success')
            allow(controller).to receive(:store_agreement).and_return(messages: { success: ['Success'] }, status: :ok)
            stub_const('Settings', route_settings)
          end
          it 'returns correct upload message' do
            put :update, params: { id: '1000008890' }
            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)['errors']).not_to be_present
            expect(JSON.parse(response.body)['success']).to be_present
            expect(JSON.parse(response.body)).not_to be_nil
          end
        end
        describe 's3 upload fails' do
          before do
            allow(controller).to receive(:put_agreement).and_return('Success')
            allow(controller).to receive(:store_agreement).and_return(messages: { success: ['Success'], errors: ['Error'] }, status: :multi_status)
            stub_const('Settings', route_settings)
          end
          it 'returns 207 multi-status' do
            put :update, params: { id: '1000008890' }
            expect(response).to have_http_status(207)
            expect(JSON.parse(response.body)['errors']).to be_present
            expect(JSON.parse(response.body)['success']).to be_present
            expect(JSON.parse(response.body)).not_to be_nil
          end
        end
        describe 'agreement upload fails' do
          before do
            allow(controller).to receive(:put_agreement).and_return('Error')
            allow(controller).to receive(:store_agreement).and_return(messages: { errors: ['Error', 'Error'] }, status: :bad_request)
            stub_const('Settings', route_settings)
          end
          it 'returns 400 bad request' do
            put :update, params: { id: '1000008890' }
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)['errors']).to be_present
            expect(JSON.parse(response.body)['success']).not_to be_present
            expect(JSON.parse(response.body)).not_to be_nil
          end
        end
      end
      context 'not authenticated' do
        before do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, nil)
        end
        it 'sends error message to the client' do
          put :update, params: { id: '1000008890' }
          expect(response).to have_http_status(403)
          expect(JSON.parse(response.body)['errors']).to include 'You are not authorized'
        end
        it "doesn't assign response" do
          expect(assigns(:response)).to be_nil
        end
      end
    end
  end
end
