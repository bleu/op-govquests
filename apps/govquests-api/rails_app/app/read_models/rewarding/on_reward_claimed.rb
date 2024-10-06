module Rewarding
  class OnRewardClaimed
    def call(event)
      reward = RewardReadModel.find_by(reward_id: event.data[:reward_id])
      if reward
        reward.update(claimed: true, delivery_status: "Claimed")
      else
        Rails.logger.warn "Reward #{event.data[:reward_id]} not found for RewardClaimed event"
      end
    end
  end
end
