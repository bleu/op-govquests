module Gamification
  class OnTierAchieved
    def call(event)
      profile_id = event.data[:profile_id]
      tier = event.data[:tier]

      game_profile = GameProfileReadModel.find_by(profile_id: profile_id)
      if game_profile
        game_profile.update(tier: tier)
        Rails.logger.info "Updated tier to #{tier} for GameProfile #{profile_id}"
      else
        Rails.logger.warn "GameProfile #{profile_id} not found for TierAchieved event"
      end
    end
  end
end
