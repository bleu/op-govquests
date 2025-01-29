module Types
  class TierType < Types::BaseObject
    field :tier_id, String, null: false
    field :display_data, Types::TierDisplayDataType, null: false
    field :min_delegation, Integer, null: false
    field :max_delegation, Integer
    field :multiplier, Float, null: false
    field :image_url, String, null: false

    field :leaderboard, Types::LeaderboardType, null: false
    field :game_profiles, [Types::GameProfileType], null: false
  end
end
