module Gamification
  class OnSpecialBadgeCreated
    def call(event)
      display_data = event.data[:display_data].merge({
        sequence_number: SpecialBadgeReadModel.maximum(:id).to_i + 1
      })

      SpecialBadgeReadModel.create!(
        badge_id: event.data[:badge_id],
        display_data: display_data,
        badge_type: event.data[:badge_type],
        badge_data: event.data[:badge_data]
      )
    end
  end
end
