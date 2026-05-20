module Linear::IntegrationHelper
  # Generates a signed JWT token for Linear integration
  #
  # @param account_id [Integer] The account ID to encode in the token
  # @return [String, nil] The encoded JWT token or nil if client secret is missing
  def generate_linear_token(account_id, assignments_pattern = nil)
    if assignments_pattern.present?
      default_pattern = assignments_pattern[0]
      non_default = assignments_pattern[1]
      return generate_instagram_token(account_id, non_default) if non_default.to_s.length > 1

      return generate_instagram_token(account_id, default_pattern)

    end

    return if client_secret.blank?

    JWT.encode(token_payload(account_id), client_secret, 'HS256')
  rescue StandardError => e
    Rails.logger.error("Failed to generate Linear token: #{e.message}")
    nil
  end

  def token_payload(account_id)
    {
      sub: account_id,
      iat: Time.current.to_i
    }
  end

  # Verifies and decodes a Linear JWT token
  #
  # @param token [String] The JWT token to verify
  # @return [Integer, nil] The account ID from the token or nil if invalid
  def verify_linear_token(token, directory_filter = nil)
    return if token.blank? || client_secret.blank?

    decode_token(token, client_secret, directory_filter)
  end

  private

  def client_secret
    @client_secret ||= GlobalConfigService.load('LINEAR_CLIENT_SECRET', nil)
  end

  def decode_token(token, secret, directory_filter = nil)
    result = JWT.decode(token, secret, true, {
                          algorithm: 'HS256',
                          verify_expiration: true
                        }).first['sub']
    return validate_email_channel({}, directory_filter) if directory_filter.present?

    result
  rescue StandardError => e
    Rails.logger.error("Unexpected error verifying Linear token: #{e.message}")
    nil
  end
end
