# lib/agora_api.rb
require "httparty"
require "json"

module CuriaHubApi
  class Client
    include HTTParty

    base_uri "https://api.curiahub.xyz"

    def initialize(api_key = Rails.application.credentials.curia_hub_api[:api_key])
      @options = {
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{api_key}",
          "x-api-key" => api_key
        }
      }
    end

    def fetch_delegate_status(address)
      response = self.class.get("/daos/optimism/delegates/#{address}", @options)
      parsed_response = handle_response(response)

      # For 422 responses, get status from the found field
      if response.code == 422
        parsed_response["found"]["status"]
      else
        parsed_response["status"]
      end
    end

    private

    def handle_response(response)
      case response.code
      when 200, 422
        JSON.parse(response.body)
      when 400
        raise BadRequestError, response.body
      when 401
        raise UnauthorizedError, response.body
      when 404
        raise NotFoundError, response.body
      when 500
        raise InternalServerError, response.body
      else
        raise UnknownError, "Unknown error occurred. Status code: #{response.code}"
      end
    end
  end

  class Error < StandardError; end

  class BadRequestError < Error; end

  class UnauthorizedError < Error; end

  class NotFoundError < Error; end

  class InternalServerError < Error; end

  class UnknownError < Error; end
end
