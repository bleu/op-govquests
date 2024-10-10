module Rewarding
  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnRewardCreated, to: [Rewarding::RewardCreated])
      event_store.subscribe(OnRewardIssued, to: [Rewarding::RewardIssued])
      event_store.subscribe(OnRewardClaimed, to: [Rewarding::RewardClaimed])
      event_store.subscribe(OnRewardExpired, to: [Rewarding::RewardExpired])
      event_store.subscribe(OnRewardInventoryDepleted, to: [Rewarding::RewardInventoryDepleted])
    end
  end
end
