# typed: true
# frozen_string_literal: true

class EnsSubgraphClient
  include HTTParty
  class QueryError < StandardError; end

  class QueryExecutionError < StandardError; end

  class ResourceNotFound < StandardError; end

  # Initialize with API key and optional headers
  #
  # @param api_key [String] Your The Graph API key
  def initialize(api_key: Rails.application.credentials.dig(:the_graph, :api_key))
    @api_key = api_key
  end

  # Executes a GraphQL query
  #
  # @param query [String] The GraphQL query string
  # @param variables [Hash] Variables for the GraphQL query
  # @return [OpenStruct] Parsed response data
  # @raise [QueryError] If there are GraphQL errors in the response
  # @raise [QueryExecutionError] If the HTTP request fails
  def query(query, variables: {})
    payload = {query: query, variables: variables}

    response = self.class.post(endpoint, headers: headers, body: payload.to_json)

    handle_response(response)
  rescue HTTParty::Error, SocketError => e
    raise QueryExecutionError, "HTTP request failed: #{e.message}"
  end

  DOMAIN_QUERY = <<~GRAPHQL
    query($first: Int!, $owner: String!) {
      domains(first: $first, where: { owner: $owner }) {
        name
      }
    }
  GRAPHQL

  def domains(owner:, first: 100)
    query(DOMAIN_QUERY, variables: {first: first, owner: owner})
  end

  private

  # Constructs the GraphQL endpoint URL
  #
  # @return [String] The GraphQL endpoint URL
  memoize def endpoint
    "https://gateway.thegraph.com/api/#{@api_key}/subgraphs/id/5XqPmWe6gjyrJtFn9cLy237i4cWw2j9HcUJEXsP5qGtH"
  end

  # Sets up the HTTP headers
  #
  # @return [Hash] Headers for the HTTP request
  def headers
    {
      "Content-Type" => "application/json",
      "Accept" => "application/json"
    }
  end

  # Handles the HTTP response
  #
  # @param response [HTTParty::Response] The HTTP response
  # @return [OpenStruct] Parsed response data
  # @raise [QueryError] If there are GraphQL errors in the response
  def handle_response(response)
    if response.success?
      body = response.parsed_response

      if body["errors"]
        error_messages = body["errors"].map { |error| error["message"] }.join(", ")
        raise QueryError, "GraphQL Errors: #{error_messages}"
      end

      data = body["data"] || {}
      # Convert keys to snake_case and wrap in OpenStruct
      parsed_data = data.deep_transform_keys(&:underscore)
      OpenStruct.new(parsed_data)
    else
      raise QueryExecutionError, "HTTP Error: #{response.code} - #{response.body}"
    end
  end
end
