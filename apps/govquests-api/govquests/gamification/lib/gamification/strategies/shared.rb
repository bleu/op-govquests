module Gamification
  module Strategies
    module Shared
      def verify_delegatee_voting_power(amount_delegated:, delegatee_data:, maximum_voting_power:)
        total_delegated = BigDecimal(amount_delegated) / BigDecimal("1e18")

        delegatee_voting_power_raw = delegatee_data.dig("votingPower", "total").to_i
        delegatee_voting_power = BigDecimal(delegatee_voting_power_raw) / BigDecimal("1e18")

        delegatee_voting_power - total_delegated <= maximum_voting_power
      end

      def verify_delegate_active(delegate_data)
        # TODO: update this when curiahub governance API is available
        # https://linear.app/bleu-builders/issue/OPGOV-749
        delegate_data.dig("lastTenProps").to_i >= 7
      end
    end
  end
end