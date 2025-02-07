module Gamification
  class OnLeaderboardUpdated
    class LeaderboardUpdateError < StandardError; end

    def call(event)
      leaderboard_id = event.data[:leaderboard_id]

      UpdateLeaderboardRanksJob.perform_later(leaderboard_id)
    end
  end
end
