module Gamification
  class OnStreakMaintained
    def call(event)
      profile_id = event.data[:profile_id]
      streak = event.data[:streak]

      game_profile = GameProfileReadModel.find_by(profile_id: profile_id)
      if game_profile
        game_profile.update(streak: streak)
        Rails.logger.info "Updated streak to #{streak} for GameProfile #{profile_id}"
      else
        Rails.logger.warn "GameProfile #{profile_id} not found for StreakMaintained event"
      end
    end
  end
end
