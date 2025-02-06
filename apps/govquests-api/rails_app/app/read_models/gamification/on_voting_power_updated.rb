module Gamification
  class OnVotingPowerUpdated
    def call(event)
      profile_id = event.data[:profile_id]
      voting_power = {
        total_voting_power: event.data[:total_voting_power],
        voting_power_relative_to_votable_supply: event.data[:voting_power_relative_to_votable_supply]
      }

      game_profile = GameProfileReadModel.find_by(profile_id: profile_id)
      game_profile.update!(voting_power: voting_power)
    end
  end
end
