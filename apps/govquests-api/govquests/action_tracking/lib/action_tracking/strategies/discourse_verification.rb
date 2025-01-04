require_relative "base"
require "openssl"
require "base64"
require "securerandom"
require "net/http"

module ActionTracking
  module Strategies
    class DiscourseVerification < Base
      DISCOURSE_HOST = "https://gov.optimism.io"

      def start_execution
        rsa_key = OpenSSL::PKey::RSA.new(2048)
        nonce = SecureRandom.hex(16)
        public_key_pem = rsa_key.public_key.to_pem

        query_params = {
          "application_name" => "GovQuests",
          "client_id" => SecureRandom.urlsafe_base64,
          "scopes" => "read",
          "public_key" => public_key_pem,
          "nonce" => nonce
        }

        query_string = URI.encode_www_form(query_params)
        url = "#{DISCOURSE_HOST}/user-api-key/new?#{query_string}"

        {
          action_type: "discourse_verification",
          private_key: rsa_key.to_pem,
          nonce: nonce,
          verification_url: url
        }
      end

      def complete_execution(dry_run: false)
        return false if dry_run

        raise CompletionDataVerificationFailed, "No encrypted key provided" if completion_data[:encrypted_key].blank?
        private_key_pem = start_data["private_key"]
        raise CompletionDataVerificationFailed, "Private key not found" if private_key_pem.nil?

        rsa_private_key = OpenSSL::PKey::RSA.new(private_key_pem)
        begin
          decrypted_payload = rsa_private_key.private_decrypt(
            Base64.decode64(completion_data[:encrypted_key]),
            OpenSSL::PKey::RSA::PKCS1_PADDING
          )
        rescue => e
          raise CompletionDataVerificationFailed, "Error decrypting key: #{e.message}"
        end
        
        data = JSON.parse(decrypted_payload)
        api_key = data["key"]
        discourse_username = fetch_discourse_username(api_key)

        {
          action_type: "discourse_verification",
          discourse_username: discourse_username,
          api_key: api_key
        }
      end

      private

      def fetch_discourse_username(api_key)
        url = URI.parse("#{DISCOURSE_HOST}/session/current.json")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true if url.scheme == "https"

        headers = {
          "User-Api-Key" => api_key,
        }

        request = Net::HTTP::Get.new(url.request_uri, headers)
        response = http.request(request)
        if response.code != "200"
          raise CompletionDataVerificationFailed, "Error fetching user info: #{response.body}"
        end

        user_info = JSON.parse(response.body)
        user_info["current_user"]["username"]
      end
    end
  end
end
