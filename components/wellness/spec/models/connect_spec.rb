# frozen_string_literal: true

require 'rails_helper'
require 'redis'

RSpec.describe Connect do
  before :each do
    @redis = Redis.new(db: Rails.application.credentials[:redis][:environment][Rails.env.to_sym])
    @redis.flushdb
    expect(@redis.get(:authorization)).to be_nil
    VCR.use_cassette('vcp_login') do
      @client = Connect.new
    end
  end

  describe 'redis' do
    context 'no auth cached' do
      it 'requests new auth from client' do
        expect(@redis.get(:authorization)).not_to be_nil
      end
    end

    context 'auth cached' do
      it 'requests new auth if expired' do
        expired_auth = JSON.parse(@redis.get(:authorization))
        expired_auth['request_date'] = (DateTime.now - 10.years).to_i
        @redis.set(:authorization, expired_auth.to_json)
        VCR.use_cassette('vcp_login') do
          @client = Connect.new
        end
        new_auth = JSON.parse(@redis.get(:authorization))
        expect(expired_auth).not_to eql(new_auth)
      end

      it 'does not update if valid' do
        auth = @redis.get(:authorization)
        VCR.use_cassette('vcp_login') do
          @client = Connect.new
        end
        new_auth = @redis.get(:authorization)
        expect(auth).to eql(new_auth)
      end
    end
  end
end
