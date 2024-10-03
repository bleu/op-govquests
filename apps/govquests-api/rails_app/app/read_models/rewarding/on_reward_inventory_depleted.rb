module Rewarding
  class OnRewardInventoryDepleted
    def call(event)
      reward = RewardReadModel.find_by(reward_id: event.data[:reward_id])
      if reward
        reward.update(delivery_status: "InventoryDepleted")
      else
        Rails.logger.warn "Reward #{event.data[:reward_id]} not found for RewardInventoryDepleted event"
      end
    end
  end
end
