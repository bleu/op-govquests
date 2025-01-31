module Gamification
  class OnVotingPowerUpdated
    def call(event)
      profile_id = event.data[:profile_id]
      voting_power = event.data[:voting_power]

      game_profile = GameProfileReadModel.find_by(profile_id: profile_id)
      game_profile.update!(voting_power: voting_power)
    end
  end
end
