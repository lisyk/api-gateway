# frozen_string_literal: true

require 'rails_helper'
require(File.expand_path('../../app/controllers/api/v1/api_controller'))

module Wellness
  RSpec.describe PlansController, type: :controller do
    routes { Wellness::Engine.routes }
    let(:plans_sample_file) { File.read(File.expand_path('../../helpers/dummy_docs/plans/origin_plans_sample.json', __dir__)) }
    let(:wellness_plans) { JSON.parse plans_sample_file }

    describe 'GET #index' do
      context 'authenticated' do
        before :each do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, 'authorized')
          stub_const('Settings', route_settings)
        end
        it "assigns current user" do
          expect(assigns(:current_user)).to be 'authorized'
        end
        describe 'plans service available' do
          before do
            allow(controller).to receive(:fetch_plans).and_return wellness_plans
          end
          it 'returns wellness plans' do
            get :index
            expect(response).to have_http_status(200)
            expect(assigns(:wellness_plans)).not_to be_nil
          end
        end
        describe 'plans service is not available' do
          before do
            allow(controller).to receive(:fetch_plans).and_return nil
          end
          it 'returns 404 error message' do
            get :index
            expect(response).to have_http_status(404)
            expect(JSON.parse(response.body)['errors']).to include 'Wellness plans are not available.'
          end
        end
      end
      context 'not authenticated' do
        before do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, nil)
        end
        it 'sends error message to the client' do
          get :index
          expect(response).to have_http_status(403)
          expect(JSON.parse(response.body)['errors']).to include 'You are not authorized'
        end
        it "doesn't assign current user" do
          expect(assigns(:current_user)).to be_nil
        end
      end
    end
  end
end
