module Rewarding
  class OnRewardCreated
    def call(event)
      reward_id = event.data.fetch(:reward_id)
      reward_type = event.data.fetch(:reward_type)
      value = event.data.fetch(:value)
      expiry_date = event.data[:expiry_date]

      reward = RewardReadModel.find_or_initialize_by(reward_id: reward_id)
      reward.reward_type = reward_type
      reward.value = value
      reward.expiry_date = expiry_date
      reward.delivery_status = "Pending"
      reward.save!
    end
  end
end
