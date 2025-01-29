module Types
  class LeaderboardType < Types::BaseObject
    field :leaderboard_id, String, null: false
    field :tier, Types::TierType, null: false
    field :game_profiles, [Types::GameProfileType], null: false do
      argument :limit, Integer, required: false, default_value: 10
      argument :offset, Integer, required: false, default_value: 0
    end

    def game_profiles(limit:, offset:)
      object.game_profiles.order(:rank).limit(limit).offset(offset)
    end
  end
end
