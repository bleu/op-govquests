module Rewarding
  class OnRewardExpired
    def call(event)
      reward = RewardReadModel.find_by(reward_id: event.data[:reward_id])
      if reward
        reward.update(delivery_status: "Expired")
      else
        Rails.logger.warn "Reward #{event.data[:reward_id]} not found for RewardExpired event"
      end
    end
  end
end
