class JwtService
  ALGORITHM = "HS256"
  EXPIRY    = 24.hours

  def self.encode(payload, exp: EXPIRY.from_now.to_i)
    payload = payload.merge(
      exp: exp,
      jti: SecureRandom.uuid,
      iat: Time.current.to_i
    )
    JWT.encode(payload, secret, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, secret, true, algorithm: ALGORITHM)
    payload = HashWithIndifferentAccess.new(decoded.first)

    raise JWT::DecodeError, "Token has been revoked" if JwtDenylist.revoked?(payload[:jti])

    payload
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end

  def self.revoke!(token)
    payload = decode_without_verification(token)
    return unless payload

    JwtDenylist.revoke!(payload[:jti], payload[:exp])
  end

  def self.secret
    Rails.application.credentials.jwt_secret ||
      ENV.fetch("JWT_SECRET", "fallback_dev_secret_change_in_production")
  end

  def self.decode_without_verification(token)
    decoded = JWT.decode(token, nil, false)
    HashWithIndifferentAccess.new(decoded.first)
  rescue JWT::DecodeError
    nil
  end
end
