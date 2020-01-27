# frozen_string_literal: true

class JwtAuthToken
  def self.encode(payload)
    exp = set_token_expiration.to_i
    JWT.encode(payload.merge(exp: exp), Rails.application.secret_key_base)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secret_key_base).first
  end

  def self.set_token_expiration
    ENV['JWT_TOKEN_EXPIRATION_IN_HOURS'].to_i.hours.from_now
  end

  private_class_method :set_token_expiration
end
