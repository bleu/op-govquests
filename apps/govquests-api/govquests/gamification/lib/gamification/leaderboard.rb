module Gamification
  class Leaderboard
    include AggregateRoot

    def initialize(id)
      @id = id
    end

    def update_ranking
      apply LeaderboardUpdated.new(data: {
        leaderboard_id: @id
      })
    end

    private

    on LeaderboardUpdated do |event| end
  end
end
