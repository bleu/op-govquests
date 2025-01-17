module Resolvers
  class FetchBadges < BaseResolver
    type [Types::BadgeType], null: true

    def resolve
      current_user = context[:current_user]
      badges = Gamification::BadgeReadModel.includes(:user_badges)

      return badges unless current_user

      earned_badge_ids = Gamification::UserBadgeReadModel
        .where(user_id: current_user.user_id)
        .where(badgeable_type: "Gamification::BadgeReadModel")
        .pluck(:badgeable_id)

      return badges if earned_badge_ids.empty?

      badges.order(
        Arel.sql(
          "CASE WHEN badges.id IN (#{earned_badge_ids.join(",")}) THEN 0 ELSE 1 END"
        )
      )
    end
  end
end
