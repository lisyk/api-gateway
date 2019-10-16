# frozen_string_literal: true

require 'rails_helper'
require(File.expand_path('../../app/controllers/api/v1/api_controller'))

module Wellness
  RSpec.describe PlansController, type: :controller do
    routes { Wellness::Engine.routes }
    before :each do
      controller.instance_variable_set(:@current_user, 'authorized')
      allow(controller).to receive(:authenticate!).and_return true
    end

    describe 'GET #index' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end
end
