module Gamification
  class OnBadgeEarned
    def call(event)
      profile_id = event.data[:profile_id]
      badge = event.data[:badge]

      game_profile = GameProfileReadModel.find_by(profile_id: profile_id)
      if game_profile
        badges = game_profile.badges || []
        if badges.include?(badge)
          Rails.logger.info "Badge '#{badge}' already exists for GameProfile #{profile_id}"
        else
          game_profile.update(badges: badges + [ badge ])
          Rails.logger.info "Added badge '#{badge}' to GameProfile #{profile_id}"
        end
      else
        Rails.logger.warn "GameProfile #{profile_id} not found for BadgeEarned event"
      end
    end
  end
end
