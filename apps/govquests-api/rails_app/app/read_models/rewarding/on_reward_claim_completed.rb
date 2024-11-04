module Rewarding
  class OnRewardClaimCompleted
    def call(event)
      issuance = RewardIssuanceReadModel.find_by!(
        pool_id: event.data[:pool_id],
        profile_id: event.data[:profile_id]
      )

      issuance.update!(
        claim_completed_at: event.data[:claimed_at],
        claim_metadata: event.data.fetch(:claim_metadata).merge(issuance.claim_metadata)
      )
    end
  end
end
