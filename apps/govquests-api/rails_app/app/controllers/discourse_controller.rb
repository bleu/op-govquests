# app/controllers/discourse_controller.rb
class DiscourseController < ApplicationController
  require "openssl"
  require "base64"
  require "securerandom"
  require "net/http"

  def authorize
    # Generate RSA key pair
    rsa_key = OpenSSL::PKey::RSA.new(2048)
    session[:discourse_private_key] = rsa_key.to_pem

    # Generate a random nonce
    nonce = SecureRandom.hex(16)
    session[:discourse_nonce] = nonce

    # Discourse site details
    discourse_host = "https://gov.optimism.io"
    path = "/user-api-key/new"

    # Prepare parameters
    public_key_pem = rsa_key.public_key.to_pem
    query_params = {
      "application_name" => "MyApp",
      "client_id" => SecureRandom.urlsafe_base64,
      "scopes" => "read",
      "public_key" => public_key_pem,
      # "auth_redirect" => "http://localhost:3000/discourse/callback",
      "nonce" => nonce
    }

    # Build the URL
    query_string = URI.encode_www_form(query_params)
    url = "#{discourse_host}#{path}?#{query_string}"

    # Output the URL for the user to visit
    puts "Please visit the following URL to generate your API key: #{url}\n"
    puts "After you obtain the encrypted private key, paste it below:"

    # Get the encrypted key directly from the terminal input
    encrypted_key = gets.chomp

    if encrypted_key.blank?
      puts "Error: No key provided"
      return
    end

    # Proceed with decryption and verification
    verify_key(encrypted_key)
  end

  private

  def verify_key(encrypted_key)
    # Retrieve the private key from the session
    private_key_pem = session[:discourse_private_key]
    if private_key_pem.nil?
      puts "Error: Private key not found in session"
      return
    end
    rsa_private_key = OpenSSL::PKey::RSA.new(private_key_pem)

    # Decrypt the payload
    begin
      decrypted_payload = rsa_private_key.private_decrypt(
        Base64.decode64(encrypted_key),
        OpenSSL::PKey::RSA::PKCS1_PADDING
      )
    rescue => e
      puts "Error decrypting key: #{e.message}"
      return
    end

    data = JSON.parse(decrypted_payload)
    api_key = data["key"]

    # Make a request to Discourse to get the username
    discourse_host = "https://gov.optimism.io"
    url = URI.parse("#{discourse_host}/session/current.json")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == "https"

    headers = {
      "User-Api-Key" => api_key,
      "User-Api-Client-Id" => "MyApp"
    }

    request = Net::HTTP::Get.new(url.request_uri, headers)
    response = http.request(request)

    puts response.body
    if response.code != "200"
      puts "Error fetching user info: #{response.body}"
      return
    end

    # Extract username and update user as verified
    discourse_username = response["-discourse-username"]
    if discourse_username.nil?
      user_info = JSON.parse(response.body)
      discourse_username = user_info["current_user"]["username"]
    end

    puts "Discourse username: #{discourse_username}"
    puts "API key: #{api_key}"

    # Notify the user via console
    puts "You've been verified as #{discourse_username}"
  end
end
