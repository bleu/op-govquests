module Gamification
  class DetermineTierService
    class << self
      def determine_tier(address:)
        total_voting_power = if address.present?
          delegate = agora_client.get_delegate(address)
          delegate.dig("votingPower", "total").to_i
        else
          0
        end

        tiers = TierReadModel.order(min_delegation: :desc)
        tiers.find { |tier| total_voting_power >= tier.min_delegation }
      end

      private

      def agora_client
        @agora_client ||= AgoraApi::Client.new
      end
    end
  end
end
