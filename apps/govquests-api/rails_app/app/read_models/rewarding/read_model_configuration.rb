module Rewarding
  class RewardReadModel < ApplicationRecord
    self.table_name = "rewards"

    validates :reward_id, presence: true, uniqueness: true
    # Other validations...
  end

  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnRewardCreated, to: [ Rewarding::RewardCreated ])
      event_store.subscribe(OnRewardIssued, to: [ Rewarding::RewardIssued ])
      event_store.subscribe(OnRewardClaimed, to: [ Rewarding::RewardClaimed ])
      event_store.subscribe(OnRewardExpired, to: [ Rewarding::RewardExpired ])
      event_store.subscribe(OnRewardInventoryDepleted, to: [ Rewarding::RewardInventoryDepleted ])
    end
  end
end
