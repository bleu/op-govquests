module Gamification
  class OnSpecialBadgeCreated
    def call(event)
      SpecialBadgeReadModel.create!(
        badge_id: event.data[:badge_id],
        display_data: event.data[:display_data],
        badge_type: event.data[:badge_type],
        badge_data: event.data[:badge_data],
        points: event.data[:points]
      )
    end
  end
end
