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
        VCR.use_cassette('login/vcp_login_no_auth') do
          response = unauthorized_client.post('login', username: 'test', password: 'test')
          expect(response.status).to eql(401)
        end
      end
    end
    describe 'correct credentials' do
      it 'returns a bearer token' do
        VCR.use_cassette('login/vcp_login_auth') do
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
        VCR.use_cassette('login/vcp_plan_auth') do
          response = authorized_client.get('plan')
          expect(response.status).to eql(200)
        end
      end
    end
    describe 'incorrect credentials' do
      it 'returns 401' do
        VCR.use_cassette('login/vcp_plan_no_auth') do
          response = unauthorized_client.get('plan')
          expect(response.status).to eql(401)
        end
      end
    end
  end
  context 'GET /contractApplication' do
    context 'index' do
      describe 'correct credentials' do
        it 'returns a list of contract applications' do
          VCR.use_cassette('contract/vcp_contract_application_index_auth') do
            response = authorized_client.get('contractApplication')
            expect(response.status).to eql(200)
          end
        end
      end
      describe 'incorrect credentials' do
        it 'returns 401' do
          VCR.use_cassette('contract/vcp_contract_application_index_no_auth') do
            response = unauthorized_client.get('contractApplication')
            expect(response.status).to eql(401)
          end
        end
      end
    end
    context 'show' do
      describe 'correct credentials' do
        it 'returns a contract application' do
          VCR.use_cassette('contract/vcp_contract_application_show_auth') do
            response = authorized_client.get('contractApplication')
            expect(response.status).to eql(200)
          end
        end
      end
      describe 'incorrect credentials' do
        it 'returns 401' do
          VCR.use_cassette('contract/vcp_contract_application_show_no_auth') do
            response = unauthorized_client.get('contractApplication')
            expect(response.status).to eql(401)
          end
        end
      end
    end
  end
  context 'GET /contractApplicationAgreement' do
    context 'show' do
      describe 'correct credentials' do
        it 'returns a contract application' do
          VCR.use_cassette('contract/vcp_contract_agreement_show_auth') do
            response = authorized_client.get('contractApplicationAgreement')
            expect(response.status).to eql(200)
          end
        end
      end
      describe 'incorrect credentials' do
        it 'returns 401' do
          VCR.use_cassette('contract/vcp_contract_agreement_show_no_auth') do
            response = unauthorized_client.get('contractApplicationAgreement')
            expect(response.status).to eql(401)
          end
        end
      end
    end
  end
end
