# frozen_string_literal: true

class JsonWebToken
  ALGORITHM ||= 'HS256'
  ACCESS_TOKEN_TTL ||= 30.minutes
  REFRESH_TOKEN_TTL ||= 20.days
  USER_IDENTIFIER ||= :user

  def self.encode(payload, expiration = (Time.now.utc + ACCESS_TOKEN_TTL).to_i)
    payload[:exp] = expiration
    JWT.encode(payload, key, ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token, key,
               true, algorithm: ALGORITHM).first
  rescue
    false
  end

  def self.key
    Rails.application.secrets.secret_jwt_key
  end
end
