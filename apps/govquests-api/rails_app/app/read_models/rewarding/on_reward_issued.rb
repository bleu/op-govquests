module Rewarding
  class OnRewardIssued
    def call(event)
      pool = RewardPoolReadModel.find_by(pool_id: event.data[:pool_id])
      return unless pool

      pool.issued_rewards.create!(
        user_id: event.data[:user_id],
        issued_at: event.data[:issued_at]
      )

      if pool.reward_definition["type"] == "Token"
        pool.decrement!(:remaining_inventory)
      end
    end
  end
end
