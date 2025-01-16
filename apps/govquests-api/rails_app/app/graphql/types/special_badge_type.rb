module Types
  class SpecialBadgeType < Types::BaseObject
    field :id, ID, null: false, method: :badge_id
    field :display_data, Types::BadgeDisplayDataType, null: false
    field :points, Integer, null: false
    field :badge_type, String, null: false
    field :current_user_badges, [Types::UserBadgeType], null: false

    def current_user_badges
      Loaders::AssociationLoader.for(
        Gamification::SpecialBadgeReadModel,
        :user_badges
      ).load(object).then do |user_badges|
        user_badges.where(user_id: context[:current_user].id)
      end
    end
  end
end
