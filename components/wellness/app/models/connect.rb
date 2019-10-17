# frozen_string_literal: true

class Connect
  attr_reader :url, :client, :token

  def initialize
    @url = base_uri
    @client = client
    @token = auth_token
  end

  private

  def client
    Faraday.new(url: url) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
      faraday.headers['Authorization'] = "Bearer #{token}" if token.present?
    end
  end

  def get_token
    token_resp = client.post('login', username: vcp_username, password: vcp_password)
    JSON.parse(token_resp.body)['access_token']
  end

  def auth_token
    get_token unless cached_token
  end

  def cached_token
    # TODO: cache token on our side
    false
  end

  def token_expired
    # TODO: expired token
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
