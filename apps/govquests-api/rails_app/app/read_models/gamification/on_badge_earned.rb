module Gamification
  class OnBadgeEarned
    def call(event)
      user_id = event.data[:user_id]
      badgeable_id = event.data[:badgeable_id]
      badgeable_type = event.data[:badgeable_type]
      earned_at = event.data[:earned_at]

      return if badgeable_type == "Gamification::BadgeReadModel" &&
        UserBadgeReadModel.exists?(
          user_id:,
          badgeable_id: badgeable_id,
          badgeable_type: badgeable_type
        )

      UserBadgeReadModel.create!(
        user_id:,
        badgeable_id: badgeable_id,
        badgeable_type: badgeable_type,
        earned_at: earned_at
      )
    end
  end
end
