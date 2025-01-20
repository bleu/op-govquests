module Gamification
  class UserBadge
    include AggregateRoot

    def initialize(id)
      @id = id
    end

    def earn_badge(user_id, badge_id, badge_type, earned_at)
      apply BadgeEarned.new(data: {
        user_id:,
        badge_id:,
        badge_type:,
        earned_at:,
      })
    end

    private

    on BadgeEarned do |event|
      @user_id = event.data[:user_id]
      @badge_id = event.data[:badge_id]
      @badge_type = event.data[:badge_type]
      @earned_at = event.data[:earned_at]
    end
  end
end
