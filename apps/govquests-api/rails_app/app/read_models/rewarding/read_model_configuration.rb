module Rewarding
  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnRewardPoolCreated, to: [Rewarding::RewardPoolCreated])
      event_store.subscribe(OnRewardIssued, to: [Rewarding::RewardIssued])
    end
  end
end
