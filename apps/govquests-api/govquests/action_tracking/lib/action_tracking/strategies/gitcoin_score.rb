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

      GITCOIN_SCORE_HUMANITY_THRESHOLD = 40

      def initialize(start_data: nil, completion_data: nil, gitcoin_api: GitcoinPassportApi.new)
        super(start_data:, completion_data:)
        @gitcoin_api = gitcoin_api
      end

      def complete_execution
        raise CompletionDataVerificationFailed.new("Your current gitcoin score is #{passport_response["score"].to_f}, which is below the threshold of #{GITCOIN_SCORE_HUMANITY_THRESHOLD}") unless passport_response["score"].to_f >= GITCOIN_SCORE_HUMANITY_THRESHOLD

        super
      end

      protected

      def completion_data_valid?
        gitcoin_passport_response = passport_response

        Types::CompletionDataInput.new(@completion_data) && gitcoin_passport_response["score"].to_f >= GITCOIN_SCORE_HUMANITY_THRESHOLD
      end

      def on_start_execution
        response = @gitcoin_api.get_signing_message

        start_data.merge({
          nonce: response["nonce"],
          message: response["message"]
        })
      end

      def on_complete_execution      
        result = get_result(passport_response)

        completion_data.merge(result)
      end

      def passport_response        
        @passport_response = {"address"=>"0xf7eb9267bac21e05a3d792275ddcbd520b5cacfe",
          "score"=>"33.60400000000000131361588274",
          "status"=>"DONE",
          "last_score_timestamp"=>"2024-10-16T19:25:36.215894+00:00",
          "expiration_date"=>"2025-01-06T19:25:26.091000+00:00",
          "evidence"=>nil,
          "error"=>nil,
          "stamp_scores"=>
           {"githubContributionActivityGte#120"=>3.019,
            "githubContributionActivityGte#60"=>2.021,
            "TrustaLabs"=>0.511,
            "BinanceBABT"=>16.021,
            "ETHScore#50"=>10.012,
            "githubContributionActivityGte#30"=>2.02}}
            
            # ||= @gitcoin_api.submit_passport(completion_data[:address], completion_data[:signature], completion_data[:nonce])
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
