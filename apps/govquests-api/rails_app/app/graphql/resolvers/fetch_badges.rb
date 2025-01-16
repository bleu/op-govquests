module Resolvers
  class FetchBadges < BaseResolver
    type [Types::BadgeType], null: true

    def resolve
      current_user = context[:current_user]
      badges = Gamification::BadgeReadModel.includes(:user_badges)

      earned_badge_ids = Gamification::UserBadgeReadModel
        .where(user_id: current_user.id)
        .where(badgeable_type: "Gamification::BadgeReadModel")
        .select(:badgeable_id)

      return badges if earned_badge_ids.empty?

      badges.order(
        Arel.sql(
          "CASE WHEN id = ANY(?) THEN 0 ELSE 1 END"
        )
      ).bind_values([earned_badge_ids])
    end
  end
end
