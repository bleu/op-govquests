module Rewarding
  module Strategies
    class Base
      class ClaimVerificationFailed < StandardError; end

      attr_reader :reward_definition, :user_id, :claim_metadata

      def initialize(reward_definition:, user_id:, claim_metadata: {})
        @reward_definition = reward_definition
        @user_id = user_id
        @claim_metadata = claim_metadata
      end

      def auto_complete?
        false
      end

      def prepare_claim
        on_prepare_claim
      end

      def complete_claim
        validate_claim_metadata
        on_complete_claim
      end

      private

      def on_prepare_claim
        {}
      end

      def on_complete_claim
        claim_metadata
      end

      def validate_claim_metadata
        true
      end
    end
  end
end
