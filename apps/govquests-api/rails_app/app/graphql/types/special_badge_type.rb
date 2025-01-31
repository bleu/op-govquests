module Types
  class SpecialBadgeType < Types::BaseObject
    field :id, ID, null: false, method: :badge_id
    field :display_data, Types::BadgeDisplayDataType, null: false
    field :reward_pools, [Types::RewardPoolType], null: false
    field :badge_type, String, null: false
    field :user_badges, [Types::UserBadgeType], null: false
    field :earned_by_current_user, Boolean, null: false

    def user_badges
      object.user_badges.where(user: context[:current_user])
    end

    def earned_by_current_user
      object.user_badges.exists?(user: context[:current_user])
    end
  end
end
