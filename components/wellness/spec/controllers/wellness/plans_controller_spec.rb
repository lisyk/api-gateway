require 'rails_helper'
require(File.expand_path('../../app/controllers/api/v1/api_controller'))

module Wellness
  RSpec.describe PlansController, type: :controller do
    routes { Wellness::Engine.routes }
    let(:settings_yaml) { YAML.load(File.read(File.expand_path('../../../../config/settings/test.yml', Rails.root))) }
    let(:settings_convert) { settings_yaml.to_json }
    let(:settings) { JSON.parse(settings_convert, object_class: OpenStruct) }

    describe "GET #index" do
      context "authenticated" do
        before :each do
          controller.instance_variable_set(:@current_user, 'authorized')
          allow(controller).to receive(:authenticate!).and_return true
          stub_const('Settings', settings)
        end
        it 'returns wellness plans' do
          get :index
          expect(response).to have_http_status(200)
          expect(assigns(:wellness_plans)).not_to be_nil
        end

      end
      context "not authenticated" do
        before { allow(controller).to receive(:authenticate!).and_return false }
        it 'sends error message to the client' do
          get :index
          expect(response).to have_http_status(403)
          expect(JSON.parse(response.body)['errors']).to include 'You are not authorized'
        end
      end
    end
  end
end