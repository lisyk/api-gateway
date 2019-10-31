# frozen_string_literal: true

require 'rails_helper'
require 'faraday'

RSpec.describe 'VCP API', :vcr, type: :request do
  let(:vcp_url) do
    vcp = route_settings.api.vcp_wellness
    vcp.protocol + vcp.subdomain + vcp.domain + vcp.api_route
  end

  let(:unauthorized_client) do
    Faraday.new(url: vcp_url) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
  end

  credentials_path = Wellness::Engine.root.join('config', 'credentials.yml.enc')
  let(:username) { Rails.application.encrypted(credentials_path).auth[Rails.env.to_sym][:vcp_username] }
  let(:password) { Rails.application.encrypted(credentials_path).auth[Rails.env.to_sym][:vcp_password] }

  let(:token) do
    response = unauthorized_client.post('login', username: username, password: password)
    JSON.parse(response.body)['access_token']
  end

  let(:authorized_client) do
    Faraday.new(url: vcp_url) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
      faraday.headers['Authorization'] = "Bearer #{token}" if token.present?
    end
  end

  context 'POST /login' do
    describe 'incorrect credentials' do
      it 'returns 401' do
        response = unauthorized_client.post('login', username: 'test', password: 'test')
        expect(response.status).to eql(401)
      end
    end
    describe 'correct credentials' do
      it 'returns a bearer token' do
        response = unauthorized_client.post('login', username: username, password: password)
        expect(response.status).to eql(200)
        assert_match(/access_token/, response.body)
      end
    end
  end
  context 'GET /wellness_plans' do
    describe 'correct credentials' do
      it 'returns a list of plans' do
        response = authorized_client.get('plan')
        expect(response.status).to eql(200)
      end
    end
    describe 'incorrect credentials' do
      it 'returns 401' do
        response = unauthorized_client.get('plan')
        expect(response.status).to eql(401)
      end
    end
  end
  context 'GET /contractApplication' do
    context 'index' do
      describe 'correct credentials' do
        it 'returns a list of contract applications' do
          response = authorized_client.get('contractApplication')
          expect(response.status).to eql(200)
        end
      end
      describe 'incorrect credentials' do
        it 'returns 401' do
          response = unauthorized_client.get('contractApplication')
          expect(response.status).to eql(401)
        end
      end
    end
    context 'show' do
      describe 'correct credentials' do
        it 'returns a contract application' do
          response = authorized_client.get('contractApplication')
          expect(response.status).to eql(200)
        end
      end
      describe 'incorrect credentials' do
        it 'returns 401' do
          response = unauthorized_client.get('contractApplication')
          expect(response.status).to eql(401)
        end
      end
    end
  end
  context 'GET /contractApplicationAgreement' do
    context 'show' do
      describe 'correct credentials' do
        it 'returns a contract application' do
          response = authorized_client.get('contractApplicationAgreement')
          expect(response.status).to eql(200)
        end
      end
      describe 'incorrect credentials' do
        it 'returns 401' do
          response = unauthorized_client.get('contractApplicationAgreement')
          expect(response.status).to eql(401)
        end
      end
    end
  end
  context 'GET /planService' do
    context 'index' do
      describe 'correct credentials' do
        it 'returns a list of services' do
          VCR.use_cassette('vcp_plan_service_index_auth') do
            response = authorized_client.get('planService')
            expect(response.status).to eql(200)
          end
        end
      end
      describe 'incorrect credentials' do
        it 'returns 401' do
          VCR.use_cassette('vcp_plan_service_index_no_auth') do
            response = unauthorized_client.get('planService')
            expect(response.status).to eql(401)
          end
        end
      end
    end
  end
  context 'GET /planService' do
    context 'index' do
      describe 'correct credentials' do
        it 'returns a list of services' do
          VCR.use_cassette('vcp_plan_service_index_auth') do
            response = authorized_client.get('planService')
            expect(response.status).to eql(200)
          end
        end
      end
      describe 'incorrect credentials' do
        it 'returns 401' do
          VCR.use_cassette('vcp_plan_service_index_no_auth') do
            response = unauthorized_client.get('planService')
            expect(response.status).to eql(401)
          end
        end
      end
    end
  end
end
