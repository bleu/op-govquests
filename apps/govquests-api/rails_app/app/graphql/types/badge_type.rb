module Types
  class BadgeType < Types::BaseObject
    field :id, ID, null: false, method: :badge_id
    field :display_data, Types::BadgeDisplayDataType, null: false
    field :badgeable, Types::BadgeableUnion, null: true
    field :current_user_badges, [Types::UserBadgeType], null: false

    def current_user_badges
      Loaders::AssociationLoader.for(
        Gamification::BadgeReadModel,
        :user_badges
      ).load(object).then do |user_badges|
        user_badges.where(user_id: context[:current_user].id)
      end
    end
  end
end
