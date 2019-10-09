# frozen_string_literal: true

class JwtAuthToken
  def self.encode(payload)
    # TODO: move expiration to secret credentials, ENV variable
    exp = (DateTime.now + 1.month).to_i
    JWT.encode(payload.merge(exp: exp), Rails.application.credentials.secret_key_base)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base).first
  end
end