module Rewarding
  class OnRewardIssued
    def call(event)
      pool = RewardPoolReadModel.find_by(pool_id: event.data[:pool_id])
      return unless pool

      pool_properties = {
        user_id: event.data[:user_id],
        issued_at: event.data[:issued_at]
      }

      if pool.reward_definition["type"] == "Token"
        pool_properties[:status] = "pending"
      end

      if pool.reward_definition["type"] == "Points"
        pool_properties[:status] = "completed"
        pool_properties[:confirmed_at] = event.data[:issued_at]
      end

      pool.issued_rewards.create!(pool_properties)
    end
  end
end
