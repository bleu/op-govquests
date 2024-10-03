module Gamification
  class OnTrackCompleted
    def call(event)
      profile_id = event.data[:profile_id]
      track = event.data[:track]

      game_profile = GameProfileReadModel.find_by(profile_id: profile_id)
      if game_profile
        game_profile.update(track: track)
        Rails.logger.info "Updated track to #{track} for GameProfile #{profile_id}"
      else
        Rails.logger.warn "GameProfile #{profile_id} not found for TrackCompleted event"
      end
    end
  end
end
