module Gamification
  class OnTokenClaimCompleted
    def call(event)
      profile = GameProfileReadModel.find_by!(profile_id: event.data[:profile_id])
      token_address = event.data[:token_address]

      profile.unclaimed_tokens = profile.unclaimed_tokens.merge(token_address => 0)
      profile.active_claim = nil
      profile.save!

      Rails.logger.info "Completed token claim for profile #{profile.profile_id}: #{event.data[:amount]} #{token_address}"
    end
  end
end
