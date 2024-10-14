require_relative "base"

module ActionTracking
  module Strategies
    class GitcoinScore < Base
      module Types
        include Dry.Types()

        class CompletionDataInput < Dry::Struct
          attribute :address, Dry::Types["string"]
          attribute :signature, Dry::Types["string"]
          attribute :nonce, Dry::Types["string"]
        end
      end

      GITCOIN_SCORE_HUMANITY_THRESHOLD = 20

      def initialize(start_data: nil, completion_data: nil, gitcoin_api: GitcoinPassportApi.new)
        super(start_data:, completion_data:)
        @gitcoin_api = gitcoin_api
      end

      protected

      def completion_data_valid?
        Types::CompletionDataInput.new(completion_data) && passport_response["score"].to_f >= GITCOIN_SCORE_HUMANITY_THRESHOLD
      end

      def on_start_execution
        response = @gitcoin_api.get_signing_message

        start_data.merge({
          nonce: response["nonce"],
          message: response["message"]
        })
      end

      def on_complete_execution
        completion_data.merge({
          score: score,
          raw_response: passport_response
        })
      end

      def passport_response
        @passport_response ||= @gitcoin_api.submit_passport(data[:address], data[:signature], data[:nonce])
      end
    end
  end
end
