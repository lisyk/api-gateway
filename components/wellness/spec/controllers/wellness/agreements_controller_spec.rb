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
  end
end
