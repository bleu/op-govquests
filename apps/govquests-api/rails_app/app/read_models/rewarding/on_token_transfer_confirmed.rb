module Rewarding
  class OnTokenTransferConfirmed
    def call(event)
      reward_issuance = RewardIssuanceReadModel.find_by(pool_id: event.data[:pool_id], user_id: event.data[:user_id])
      return unless reward_issuance

      reward_issuance.update!(confirmed_at: event.data[:confirmed_at], status: "completed", claim_metadata: {
        transaction_hash: event.data[:transaction_hash]
      })
    end
  end
end
