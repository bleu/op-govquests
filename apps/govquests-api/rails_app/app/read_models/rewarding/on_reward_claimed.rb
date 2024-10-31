module Rewarding
  class OnRewardClaimed
    def call(event)
      pool = RewardPoolReadModel.find_by(pool_id: event.data[:pool_id])
      if pool

        pool.issued_rewards.find_by(user_id: event.data[:user_id])&.update!(
          claimed_at: event.data[:claimed_at]
        )
      else
        Rails.logger.warn "Reward pool #{event.data[:pool_id]} not found for RewardClaimed event"
      end
    end
  end
end
