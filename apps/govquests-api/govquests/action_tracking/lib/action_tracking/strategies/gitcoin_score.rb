require_relative "base"
require "logger"

module ActionTracking
  module Strategies
    class GitcoinScore < Base
      include Infra::Import["services.gitcoin"]

      module Types
        include Dry.Types()

        class CompletionDataInput < Dry::Struct
          attribute :address, Dry::Types["string"]
          attribute :signature, Dry::Types["string"]
          attribute :nonce, Dry::Types["string"]
        end
      end

      GITCOIN_SCORE_HUMANITY_THRESHOLD = 20

      protected

      def completion_data_valid?
        return false unless @completion_data && passport_response

        score = passport_response["score"].to_f

        return true unless score < GITCOIN_SCORE_HUMANITY_THRESHOLD

        raise CompletionDataVerificationFailed.new("Your Unique Humanity Score is currently #{score}.")
      end

      def on_start_execution
        response = gitcoin.get_signing_message

        start_data.merge({
          nonce: response["nonce"],
          message: response["message"]
        })
      end

      def on_complete_execution
        raise "Empty Gitcoin Passport response" unless passport_response

        {
          score: passport_response["score"].to_f,
          minimum_passing_score: GITCOIN_SCORE_HUMANITY_THRESHOLD,
          raw_response: passport_response
        }
      end

      private

      def passport_response
        @passport_response ||= gitcoin.submit_passport(
          @completion_data[:address],
          @completion_data[:signature],
          @completion_data[:nonce]
        )
      end
    end
  end
end
