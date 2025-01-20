module Gamification
  class OnBadgeEarned
    def call(event)
      user_id = event.data[:user_id]
      badge_id = event.data[:badge_id]
      badge_type = event.data[:badge_type]
      earned_at = event.data[:earned_at]

      UserBadgeReadModel.create!(
        user_id:,
        badge_id: badge_id,
        badge_type: badge_type,
        earned_at: earned_at
      )
    end
  end
end
