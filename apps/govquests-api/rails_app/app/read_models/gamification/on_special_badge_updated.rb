module Gamification
  class OnSpecialBadgeUpdated
    def call(event)
      special_badge = SpecialBadgeReadModel.find_by(
        badge_id: event.data[:badge_id]
      )

      special_badge.update!(
        display_data: event.data[:display_data],
        badge_data: event.data[:badge_data]
      )
    end
  end
end
