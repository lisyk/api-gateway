# frozen_string_literal: true

require 'rails_helper'
require 'faraday'

RSpec.describe 'VCP API', type: :request do
  let(:vcp_url) do
    settings_convert = YAML.safe_load(File.read(File.expand_path('../../../../config/settings/test.yml', Rails.root))).to_json
    settings = JSON.parse(settings_convert, object_class: OpenStruct)
    vcp = settings.api.vcp_wellness
    vcp.protocol + vcp.subdomain + vcp.domain + vcp.api_route
  end

  let(:unauthorized_client) do
    Faraday.new(url: vcp_url) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
  end

  let(:username) { Rails.application.credentials.auth[Rails.env.to_sym][:vcp_username] }
  let(:password) { Rails.application.credentials.auth[Rails.env.to_sym][:vcp_password] }

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
        VCR.use_cassette('vcp_login_no_auth') do
          response = unauthorized_client.post('login', username: 'test', password: 'test')
          expect(response.status).to eql(401)
        end
      end
    end
    describe 'correct credentials' do
      it 'returns a bearer token' do
        VCR.use_cassette('vcp_login_auth') do
          response = unauthorized_client.post('login', username: username, password: password)
          expect(response.status).to eql(200)
          assert_match(/access_token/, response.body)
        end
      end
    end
  end
  context 'GET /wellness_plans' do
    describe 'correct credentials' do
      it 'returns a list of plans' do
        VCR.use_cassette('vcp_plan_auth') do
          response = authorized_client.get('plan')
          expect(response.status).to eql(200)
        end
      end
    end
    describe 'incorrect credentials' do
      it 'returns 401' do
        VCR.use_cassette('vcp_plan_no_auth') do
          response = unauthorized_client.get('plan')
          expect(response.status).to eql(401)
        end
      end
    end
  end
end
