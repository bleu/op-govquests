module Rewarding
  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnRewardPoolCreated, to: [Rewarding::RewardPoolCreated])
      event_store.subscribe(OnRewardIssued, to: [Rewarding::RewardIssued])
      event_store.subscribe(OnRewardPoolUpdated, to: [Rewarding::RewardPoolUpdated])
      event_store.subscribe(OnTokenTransferConfirmed, to: [Rewarding::TokenTransferConfirmed])
    end
  end
end
