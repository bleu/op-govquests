module Types
  class GameProfileType < Types::BaseObject
    field :profile_id, String, null: false
    field :score, Integer, null: false
    field :rank, Integer, null: false
    field :tier, Types::TierType, null: false
    field :user, Types::UserType, null: false
  end
end
