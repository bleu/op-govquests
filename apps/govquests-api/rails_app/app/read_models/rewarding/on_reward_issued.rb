module Rewarding
  class OnRewardIssued
    def call(event)
      reward = RewardReadModel.find_by(reward_id: event.data[:reward_id])
      if reward
        reward.update(issued_to: event.data[:user_id], delivery_status: "Issued")
      else
        Rails.logger.warn "Reward #{event.data[:reward_id]} not found for RewardIssued event"
      end
    end
  end
end
