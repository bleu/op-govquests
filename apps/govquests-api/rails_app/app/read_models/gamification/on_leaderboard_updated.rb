module Gamification
  class OnLeaderboardUpdated
    def call(event)
      leaderboard = LeaderboardReadModel.find_by(leaderboard_id: event.data[:leaderboard_id])
      return unless leaderboard

      entry = LeaderboardEntryReadModel.find_or_initialize_by(
        leaderboard_id: event.data[:leaderboard_id],
        profile_id: event.data[:profile_id]
      )

      entry.leaderboard = leaderboard
      entry.score = event.data[:score]
      entry.rank = calculate_rank(leaderboard.leaderboard_id, entry.score)

      entry.save!
    end

    private

    def calculate_rank(leaderboard_id, score)
      higher_scores_count = LeaderboardEntryReadModel.where(leaderboard_id: leaderboard_id)
        .where("score > ?", score)
        .count
      higher_scores_count + 1
    end
  end
end
