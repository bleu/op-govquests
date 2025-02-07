module Gamification
  class OnLeaderboardUpdated
    class LeaderboardUpdateError < StandardError; end

    def call(event)
      leaderboard_id = event.data[:leaderboard_id]

      tier_id = LeaderboardReadModel.find_by(leaderboard_id: leaderboard_id)&.tier_id

      return unless tier_id.present?

      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute(
          ActiveRecord::Base.sanitize_sql_array([<<-SQL, tier_id])
            UPDATE user_game_profiles
            SET rank = ranks.new_rank
            FROM (
              SELECT 
                id,
                ROW_NUMBER() OVER (
                  ORDER BY score DESC, updated_at ASC
                ) as new_rank
              FROM user_game_profiles
              WHERE tier_id = ?
            ) ranks
            WHERE user_game_profiles.id = ranks.id
          SQL
        )
      end
    rescue => e
      Rails.logger.error("Failed to update ranks for leaderboard #{leaderboard_id}: #{e.message}")
      raise LeaderboardUpdateError, "Failed to update rankings"
    end
  end
end
