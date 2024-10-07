# lib/agora_api.rb
require "httparty"
require "json"

require_relative "agora_api/auth"
require_relative "agora_api/delegates"
require_relative "agora_api/proposals"
require_relative "agora_api/contracts"
require_relative "agora_api/retro_funding"
require_relative "agora_api/impact_metrics"
require_relative "agora_api/comments"

module AgoraApi
  class Client
    include HTTParty
    include Auth
    include Delegates
    include Proposals
    include Contracts
    include RetroFunding
    include ImpactMetrics
    include Comments

    base_uri "https://vote.optimism.io/api/v1"

    def initialize(api_key = Rails.application.credentials.agora_api[:api_key])
      @options = {
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{api_key}"
        }
      }
    end

    private

    def handle_response(response)
      case response.code
      when 200
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
