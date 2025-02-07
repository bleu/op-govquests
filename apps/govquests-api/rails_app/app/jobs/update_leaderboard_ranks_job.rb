class UpdateLeaderboardRanksJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  class LeaderboardUpdateError < StandardError; end

  def perform(leaderboard_id)
    start_time = Time.current

    tier_id = Gamification::LeaderboardReadModel.find_by(leaderboard_id: leaderboard_id)&.tier_id
    return unless tier_id.present?

    affected_rows = 0

    ActiveRecord::Base.transaction do
      result = ActiveRecord::Base.connection.execute(
        sanitize_sql_array([<<-SQL, tier_id])
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
          RETURNING id
        SQL
      )

      affected_rows = result.ntuples
    end

    elapsed_time = Time.current - start_time

    Rails.logger.info(
      "Updated leaderboard rankings: " \
      "leaderboard_id=#{leaderboard_id} " \
      "tier_id=#{tier_id} " \
      "affected_rows=#{affected_rows} " \
      "elapsed_time=#{elapsed_time.round(2)}s"
    )
  rescue => e
    Rails.logger.error("Failed to update ranks for leaderboard #{leaderboard_id}: #{e.message}")
    raise LeaderboardUpdateError, "Failed to update rankings"
  end
end
