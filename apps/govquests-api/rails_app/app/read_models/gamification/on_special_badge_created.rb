module Gamification
  class OnSpecialBadgeCreated
    def call(event)
      display_data = event.data[:display_data].merge({
        sequence_number: SpecialBadgeReadModel.maximum(:id).to_i + 1
      })

      special_badge = SpecialBadgeReadModel.find_or_initialize_by(
        badge_id: event.data[:badge_id]
      )

      special_badge.update!(
        display_data: display_data,
        badge_type: event.data[:badge_type],
        badge_data: event.data[:badge_data]
      )
    end
  end
end
