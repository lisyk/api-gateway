# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Api::V1::AuthenticationController, type: :controller do
  describe '#create' do
    context 'correct credentials' do
      let(:params) { { user_name: 'test', password: 'test' } }
      before do
        post :create, params: params
      end

      it 'assigns user admin role' do
        expect(assigns(:user)).to eq 'api_client'
      end

      it 'responds json' do
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end

      it 'responds with jwt token' do
        expect(JSON.parse(response.body)['token']).not_to be_nil
      end
    end

    context 'wrong credentials' do
      let(:params) { { user_name: 'admin', password: 'admin' } }
      before do
        post :create, params: params
      end

      it 'responds with proper status' do
        expect(response).to have_http_status(403)
      end

      it 'does not assign admin user' do
        expect(assigns(:user)).to be_nil
      end

      it 'responds with error message' do
        expect(JSON.parse(response.body)['errors']).to include 'Invalid credentials.'
      end
    end

    context 'missing params' do
      let(:params) {}
      before do
        post :create, params: params
      end

      it 'responds with error message' do
        expect(JSON.parse(response.body)).to include 'errors'
      end
    end
  end
end