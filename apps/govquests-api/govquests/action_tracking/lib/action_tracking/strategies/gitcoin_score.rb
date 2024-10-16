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

      class ActionCompletionError < StandardError
        attr_reader :data
      
        def initialize(message, data = {})
          @data = data
          super(message)
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
        response = passport_response
        score = response["score"].to_f
        passed_threshold = score >= GITCOIN_SCORE_HUMANITY_THRESHOLD
      
        result = {
          score: score,
          passed_threshold: passed_threshold,
          raw_response: response
        }
      
        if !passed_threshold
          raise ActionCompletionError.new("Gitcoin score below threshold", result)
        end
      
        completion_data.merge(result)
      end

      def passport_response
        @passport_response ||= @gitcoin_api.submit_passport(completion_data[:address], completion_data[:signature], completion_data[:nonce])
      end
    end
  end
end
