module Gamification
  class UserBadge
    include AggregateRoot

    def initialize(id)
      @id = id
    end

    def earn_badge(user_id, badgeable_id, badgeable_type, earned_at)
      apply BadgeEarned.new(data: {
        user_id:,
        badgeable_id:,
        badgeable_type:,
        earned_at:,
      })
    end

    private

    on BadgeEarned do |event|
      @user_id = event.data[:user_id]
      @badgeable_id = event.data[:badgeable_id]
      @badgeable_type = event.data[:badgeable_type]
      @earned_at = event.data[:earned_at]
    end
  end
end
