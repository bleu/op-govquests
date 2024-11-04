module Gamification
  class OnTokenClaimStarted
    def call(event)
      profile = GameProfileReadModel.find_by!(profile_id: event.data[:profile_id])

      profile.update!(
        active_claim: {
          token_address: event.data[:token_address],
          amount: event.data[:amount],
          claim_metadata: event.data[:claim_metadata],
          started_at: event.data[:started_at]
        }
      )

      Rails.logger.info "Started token claim for profile #{profile.profile_id}: #{event.data[:amount]} #{event.data[:token_address]}"
    end
  end
end
