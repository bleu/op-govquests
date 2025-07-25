module Types
  class UserBadgeType < Types::BaseObject
    field :user_id, ID, null: false, method: :user_id
    field :earned_at, GraphQL::Types::ISO8601DateTime, null: false
    field :badge, Types::BadgeUnion, null: false
    field :reward_issuances, [Types::RewardIssuanceType], null: true
  end
end
