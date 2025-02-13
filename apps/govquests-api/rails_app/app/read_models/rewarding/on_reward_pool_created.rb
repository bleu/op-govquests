module Rewarding
  class OnRewardPoolCreated
    def call(event)
      reward_pool = RewardPoolReadModel.find_or_initialize_by(
        pool_id: event.data[:pool_id]
      )

      reward_pool.update!(
        rewardable_id: event.data[:rewardable_id],
        rewardable_type: event.data[:rewardable_type],
        reward_definition: event.data[:reward_definition],
        remaining_inventory: event.data[:initial_inventory]
      )
    end
  end
end
