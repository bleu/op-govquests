module Gamification
  class OnScoreUpdated
    def call(event)
      profile_id = event.data[:profile_id]
      points = event.data[:points]

      game_profile = GameProfileReadModel.find_or_initialize_by(profile_id: profile_id)

      game_profile.update!(score: game_profile.score + points)
    end
  end
end
