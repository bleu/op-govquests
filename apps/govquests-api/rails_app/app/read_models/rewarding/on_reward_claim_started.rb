module Rewarding
  class OnRewardClaimStarted
    def call(event)
      issuance = RewardIssuanceReadModel.find_by!(
        pool_id: event.data[:pool_id],
        profile_id: event.data[:profile_id]
      )

      issuance.update!(
        claim_started_at: event.data[:claim_started_at],
        claim_metadata: event.data[:claim_metadata]
      )
    end
  end
end
