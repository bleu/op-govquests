module Gamification
  class OnBadgeUpdated
    def call(event)
      badge = BadgeReadModel.find_by(badge_id: event.data[:badge_id])
      badge.update!(display_data: event.data[:display_data])
    end
  end
end
