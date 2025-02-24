module Rewarding
  class OnRewardPoolUpdated
    def call(event)
      reward_pool = RewardPoolReadModel.find_by(pool_id: event.data[:pool_id])

      reward_pool.update!(reward_definition: event.data[:reward_definition])
    end
  end
end
