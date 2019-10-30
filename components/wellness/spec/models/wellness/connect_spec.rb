# frozen_string_literal: true

require 'rails_helper'
require 'redis'

RSpec.describe Wellness::Connect, :vcr do
  let(:redis) { Redis.new(url: ENV['REDIS_URL']) }
  subject { Wellness::Connect.new }
  before :each do
    redis.flushdb
  end

  describe 'cached token present' do
    let(:token) { JSON.parse(redis.get(:authorization)) }
    let(:client_token) { subject.client.headers['Authorization'].split(' ').last }
    before :each do
      Wellness::Connect.new
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
      it 'requests new token' do
        VCR.configuration.ignore_request { true }
        expect(client_token).not_to eq token['access_token']
        VCR.configuration.ignore_request { false }
      end
    end
  end
end
