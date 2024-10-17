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

      GITCOIN_SCORE_HUMANITY_THRESHOLD = 20
  

      def initialize(start_data: nil, completion_data: nil, gitcoin_api: GitcoinPassportApi.new)
        super(start_data:, completion_data:)
        @gitcoin_api = gitcoin_api
        @passport_response = nil
        @logger = Logger.new(STDOUT)
        @logger.level = Logger::DEBUG
      end

      def complete_execution
        validate_completion_data
        submit_passport
        validate_score
        super
      end

      protected

      def completion_data_valid?
        Types::CompletionDataInput.new(@completion_data.symbolize_keys)
        true
      rescue Dry::Struct::Error => e
        @logger.error("Invalid completion data: #{e.message}")
        false
      end

      def on_start_execution
        response = @gitcoin_api.get_signing_message

        start_data.merge({
          nonce: response["nonce"],
          message: response["message"]
        })
      end

      def on_complete_execution      
        result = get_result(@passport_response)
        @completion_data.merge(result)
      end

      private

      def validate_completion_data
        raise CompletionDataVerificationFailed.new("Invalid completion data") unless completion_data_valid?
      end

      def submit_passport
        @logger.debug("Submitting passport with data: #{@completion_data.inspect}")
        
        retries = 0
        begin
          @passport_response = @gitcoin_api.submit_passport(
            @completion_data[:address],
            @completion_data[:signature],
            @completion_data[:nonce]
          )
          @logger.debug("Received passport response: #{@passport_response.inspect}")
        rescue => e
          @logger.error("Error submitting passport: #{e.message}")
          retries += 1
          if retries < MAX_RETRIES
            @logger.info("Retrying passport submission (attempt #{retries + 1} of #{MAX_RETRIES})")
            sleep(RETRY_DELAY)
            retry
          else
            raise CompletionDataVerificationFailed.new("Failed to submit passport after #{MAX_RETRIES} attempts")
          end
        end
      end

      def validate_score
        @logger.debug("Validating score from passport response: #{@passport_response.inspect}")
        
        score = @passport_response["score"].to_f
        @logger.info("Calculated score: #{score}")
        
        if score == 0
          @logger.warn("Score is 0. This might indicate an issue with score calculation or retrieval.")
        end
        
        if score < GITCOIN_SCORE_HUMANITY_THRESHOLD
          raise CompletionDataVerificationFailed.new("Your current gitcoin score is #{score}, which is below the threshold of #{GITCOIN_SCORE_HUMANITY_THRESHOLD}")
        end
      end

      def get_result(gitcoin_passport_response)
        {
          score: gitcoin_passport_response["score"].to_f,
          passed_threshold: gitcoin_passport_response["score"].to_f >= GITCOIN_SCORE_HUMANITY_THRESHOLD,
          raw_response: gitcoin_passport_response
        }
      end
    end
  end
end