# typed: true
# frozen_string_literal: true

class DiscourseApiClient
  DISCOURSE_HOST = "https://gov.optimism.io"

  include HTTParty

  class ApiError < StandardError; end

  class AuthenticationError < ApiError; end

  class ResourceNotFound < ApiError; end

  # Generate new user API key authentication URL and credentials
  #
  # @param application_name [String] Name of the application requesting access
  # @param scopes [Array<String>] Array of requested permission scopes
  # @return [Hash] Hash containing auth URL, private key, and nonce
  def generate_auth_credentials(application_name: "GovQuests", scopes: ["read"])
    rsa_key = OpenSSL::PKey::RSA.new(2048)
    nonce = SecureRandom.hex(16)

    query_params = {
      "application_name" => application_name,
      "client_id" => SecureRandom.urlsafe_base64,
      "scopes" => Array(scopes).join(","),
      "public_key" => rsa_key.public_key.to_pem,
      "nonce" => nonce
    }

    {
      auth_url: "#{DISCOURSE_HOST}/user-api-key/new?#{URI.encode_www_form(query_params)}",
      private_key: rsa_key.to_pem,
      nonce: nonce
    }
  end

  # Verify and decrypt the user API key
  #
  # @param encrypted_payload [String] Base64 encoded encrypted payload
  # @param private_key_pem [String] PEM formatted private key
  # @return [Hash] Decrypted payload containing API key and other data
  # @raise [ApiError] If decryption fails
  def decrypt_api_key(encrypted_payload, private_key_pem)
    rsa_private_key = OpenSSL::PKey::RSA.new(private_key_pem)
    decrypted_payload = rsa_private_key.private_decrypt(
      Base64.decode64(encrypted_payload),
      OpenSSL::PKey::RSA::PKCS1_PADDING
    )
    JSON.parse(decrypted_payload)
  rescue OpenSSL::PKey::RSAError => e
    raise ApiError, "Failed to decrypt API key: #{e.message}"
  rescue JSON::ParserError => e
    raise ApiError, "Failed to parse decrypted payload: #{e.message}"
  end

  # Fetch current user information using API key
  #
  # @param api_key [String] User API key
  # @return [Hash] Current user information
  # @raise [AuthenticationError] If API key is invalid
  # @raise [ApiError] If request fails
  def fetch_current_user(api_key)
    response = self.class.get(
      "#{DISCOURSE_HOST}/session/current.json",
      headers: auth_headers(api_key)
    )

    case response.code
    when 200
      response.parsed_response
    when 401, 403
      raise AuthenticationError, "Invalid API key"
    when 404
      raise ResourceNotFound, "User not found"
    else
      raise ApiError, "Request failed with status #{response.code}: #{response.body}"
    end
  end

  def fetch_user_activity(username)
    response = self.class.get(
      "#{DISCOURSE_HOST}/u/#{username}/activity.json",
      headers: {"Accept" => "application/json"}
    )

    case response.code
    when 200
      response.parsed_response
    when 404
      raise ResourceNotFound, "User not found"
    else
      raise ApiError, "Request failed with status #{response.code}: #{response.body}"
    end
  end

  private

  def auth_headers(api_key)
    {
      "User-Api-Key" => api_key,
      "Accept" => "application/json"
    }
  end
end
