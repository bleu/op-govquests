module Gamification
  class OnGameProfileRankUpdated
    def call(event)
      profile_id = event.data[:profile_id]
      rank = event.data[:rank]

      game_profile = GameProfileReadModel.find_by(profile_id: profile_id)
      game_profile.update(rank: rank)
    end
  end
end
