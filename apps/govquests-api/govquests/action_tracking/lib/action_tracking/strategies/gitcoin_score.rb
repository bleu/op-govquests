require_relative "base"
require "logger"

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

      GITCOIN_SCORE_HUMANITY_THRESHOLD = 50

      def initialize(start_data: nil, completion_data: nil, gitcoin_api: GitcoinPassportApi.new)
        super(start_data:, completion_data:)
        @gitcoin_api = gitcoin_api
      end

      protected

      def completion_data_valid?
        validate_score
      end

      def on_start_execution
        response = @gitcoin_api.get_signing_message

        start_data.merge({
          nonce: response["nonce"],
          message: response["message"]
        })
      end

      def on_complete_execution
        {
          score: passport_response["score"].to_f,
          minimum_passing_score: GITCOIN_SCORE_HUMANITY_THRESHOLD,
          raw_response: passport_response
        }
      end

      private

      def passport_response
        @passport_response ||= @gitcoin_api.submit_passport(
          @completion_data[:address],
          @completion_data[:signature],
          @completion_data[:nonce]
        )
      end

      def validate_score
        score = passport_response["score"].to_f

        return true unless score < GITCOIN_SCORE_HUMANITY_THRESHOLD

        raise CompletionDataVerificationFailed.new("Your current gitcoin score is #{score}, which is below the threshold of #{GITCOIN_SCORE_HUMANITY_THRESHOLD}")
      end
    end
  end
end
