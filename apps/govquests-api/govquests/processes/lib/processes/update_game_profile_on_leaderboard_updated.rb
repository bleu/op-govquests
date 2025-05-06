module Processes
  class UpdateGameProfileOnLeaderboardUpdated
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Gamification::LeaderboardUpdated])
    end

    def call(event)
      leaderboard_id = event.data[:leaderboard_id]

      tier_id = LeaderboardReadModel.find_by(leaderboard_id: leaderboard_id)&.tier_id

      return unless tier_id.present?

      game_profiles = Gamification::GameProfileReadModel.where(tier_id: tier_id).order(score: :desc, updated_at: :asc)

      game_profiles.each_with_index do |game_profile, index|
        @command_bus.call(
          Gamification::UpdateGameProfileRank.new(
            profile_id: game_profile.profile_id,
            rank: index + 1
          )
        )
      end
    end
  end
end
