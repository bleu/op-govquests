module Gamification
  class Leaderboard
    include AggregateRoot

    def initialize(id)
      @id = id
      @entries = {}
    end

    def update_ranking
      apply LeaderboardUpdated.new(data: {
        leaderboard_id: @id,
      })
    end

    private

    on LeaderboardUpdated do |event|
      @entries[event.data[:profile_id]] = event.data[:score]
    end
  end
end
