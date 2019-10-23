# frozen_string_literal: true

class JwtAuthToken
  def self.encode(payload)
    exp = set_token_expiration.to_i
    JWT.encode(payload.merge(exp: exp), Rails.application.credentials.secret_key_base)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base).first
  end

  def self.set_token_expiration
    exp = DateTime.now
    Rails.application.credentials[:token][:expiration].each do |key, val|
      exp += val.send(key)
    end
    exp
  end

  private_class_method :set_token_expiration
end
