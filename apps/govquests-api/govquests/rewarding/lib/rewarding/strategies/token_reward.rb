require_relative "base"

module Rewarding
  module Strategies
    class TokenReward < Base
      private

      def on_prepare_claim
        {
          type: "token",
          token_address: reward_definition.fetch("token_address"),
          amount: reward_definition.fetch("amount"),
          recipient: claim_metadata[:user_address]
        }
      end

      def validate_claim_metadata
        raise ClaimVerificationFailed, "Missing user address" unless claim_metadata[:user_address]
      end

      def on_complete_claim
        claim_metadata
      end

      def propose_safe_transaction
      end
    end
  end
end
