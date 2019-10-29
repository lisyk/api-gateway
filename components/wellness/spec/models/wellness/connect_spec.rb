# frozen_string_literal: true

require 'rails_helper'
require 'redis'

RSpec.describe Wellness::Connect do
  let(:credentials_path) { Wellness::Engine.root.join('config', 'credentials.yml.enc') }
  let(:db) { Rails.application.encrypted(credentials_path)[:redis][:environment][Rails.env.to_sym] }
  let(:redis) { Redis.new(db: db) }
  subject { Wellness::Connect.new }
  before :each do
    redis.flushdb
  end

  describe 'cached token present' do
    let(:token) { JSON.parse(redis.get(:authorization)) }
    let(:client_token) { subject.client.headers["Authorization"].split(" ").last }
    before :each do
      VCR.use_cassette('login/vcp_login') do
        Wellness::Connect.new
      end
    end
    context 'token is valid' do
      it 'token cached' do
        expect(token).not_to be_nil
      end
      it 'uses cached token with client' do
        expect(client_token).to eq token['access_token']
      end
    end
    context 'token is not valid' do
      before :each do
        expired_auth = token
        expired_auth['request_date'] = (DateTime.now - 10.years).to_i
        redis.set(:authorization, expired_auth.to_json)
      end

      VCR.use_cassette('login/vcp_login') do
        it 'requests new token' do
          expect(client_token).not_to eq token['access_token']
        end
      end
    end
  end
end
