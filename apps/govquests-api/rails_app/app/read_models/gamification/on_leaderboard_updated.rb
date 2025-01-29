module Gamification
  class OnLeaderboardUpdated
    def call(event)
      profile_id = event.data[:profile_id]

      game_profile = GameProfileReadModel.find_or_initialize_by(profile_id: profile_id)

      ActiveRecord::Base.connection.execute(<<-SQL)
        UPDATE user_game_profiles
        SET rank = ranks.new_rank
        FROM (
          SELECT id, ROW_NUMBER() OVER (ORDER BY score DESC) as new_rank
          FROM user_game_profiles
          WHERE tier_id = '#{game_profile.tier_id}'
            AND (
              score >= #{game_profile.score} OR  -- Profiles with higher/equal scores
              id = '#{game_profile.id}'          -- The updated profile itself
            )
        ) ranks
        WHERE user_game_profiles.id = ranks.id
      SQL
    end
  end
end
