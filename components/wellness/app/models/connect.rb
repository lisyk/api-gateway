# frozen_string_literal: true

require_dependency 'redis'

class Connect
  attr_reader :url, :client, :token

  def initialize
    @url = base_uri
    @client = client
    @token = auth_token
  end

  private

  def api_client
    Faraday.new(url: url) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
      faraday.headers['Authorization'] = "Bearer #{token}" if token.present?
    end
  end

  def fetch_token
    token_resp = client.post('login', username: vcp_username, password: vcp_password)
    response_body = JSON.parse(token_resp.body)
    response_body['request_date'] = DateTime.now.to_i
    token = response_body['access_token']
    cache_token(response_body)
    token
  end

  def auth_token
    token = fetch_cached_token
    return token if token

    fetch_token
  end

  def cache_token(authorization)
    redis.set(:authorization, authorization.to_json)
  rescue Redis::CannotConnectError
    false
  end

  def fetch_cached_token
    cached_auth = redis.get(:authorization)
    if cached_auth
      auth = JSON.parse(cached_auth)
      token_expired?(auth) ? fetch_token : auth['access_token']
    else
      false
    end
  rescue Redis::CannotConnectError
    false
  end

  def token_expired?(authorization)
    request_date = authorization['request_date']
    expiration = authorization['expires_in']
    (request_date + expiration).to_i < DateTime.now.to_i
  end

  def redis
    db_params = { db: Rails.application.credentials[:redis][:environment][Rails.env.to_sym] }
    Redis.new(db_params)
  end

  def vcp_username
    Rails.application.credentials.auth[Rails.env.to_sym][:vcp_username]
  end

  def vcp_password
    Rails.application.credentials.auth[Rails.env.to_sym][:vcp_password]
  end

  def base_uri
    vcp_wellness.protocol + vcp_wellness.subdomain + vcp_wellness.domain + vcp_wellness.api_route
  end

  def vcp_wellness
    Settings.api.vcp_wellness
  end
end
