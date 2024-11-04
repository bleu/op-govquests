module Rewarding
  class OnRewardPoolCreated
    def call(event)
      RewardPoolReadModel.create!(
        pool_id: event.data[:pool_id],
        quest_id: event.data[:quest_id],
        reward_definition: event.data[:reward_definition],
        remaining_inventory: event.data[:initial_inventory]
      )
    end
  end
end
