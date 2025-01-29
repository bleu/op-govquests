module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false, method: :user_id
    field :email, String, null: true
    field :user_type, String, null: false
    field :address, String, null: false
    field :chain_id, Integer, null: false

    field :user_badges, [Types::UserBadgeType], null: true
    field :user_quests, [Types::UserQuestType], null: true
    field :user_track, [Types::UserTrackType], null: true
    field :game_profile, Types::GameProfileType, null: true
  end
end
