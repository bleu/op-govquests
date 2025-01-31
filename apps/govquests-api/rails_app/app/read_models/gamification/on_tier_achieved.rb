module Gamification
  class OnTierAchieved
    def call(event)
      profile_id = event.data[:profile_id]
      tier_id = event.data[:tier_id]

      game_profile = GameProfileReadModel.find_by(profile_id: profile_id)

      raise ProfileNotFound unless game_profile

      game_profile.update!(tier_id: tier_id)
    rescue => e
      raise EventHandlingError, "Failed to handle TierAchieved: #{e.message}"
    end
  end
end
