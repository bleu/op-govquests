# govquests/gamification/lib/gamification/leaderboard.rb
module Gamification
  class Leaderboard
    include AggregateRoot

    def initialize(id)
      @id = id
      @entries = {}
    end

    def update_score(profile_id, score)
      apply LeaderboardUpdated.new(data: {
        leaderboard_id: @id,
        profile_id: profile_id,
        score: score
      })
    end

    private

    on LeaderboardUpdated do |event|
      @entries[event.data[:profile_id]] = event.data[:score]
    end
  end
end
