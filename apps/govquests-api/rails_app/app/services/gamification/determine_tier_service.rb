module Gamification
  class DetermineTierService
    def initialize(address, agora_client: AgoraApi::Client.new)
      @address = address
      @agora_client = agora_client
    end

    def call
      delegate = @agora_client.get_delegate(@address)
      total_voting_power = delegate["votingPower"]["total"].to_i

      tiers = TierReadModel.order(min_delegation: :desc)

      tiers.find { |tier| total_voting_power >= tier.min_delegation }
    end
  end
end
