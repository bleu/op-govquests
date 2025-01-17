module Gamification
  class SpecialBadge
    include AggregateRoot

    def initialize(id)
      @id = id
      @display_data = nil
      @badge_type = nil
      @badge_data = nil
      @points = nil
    end

    def create(display_data, badge_type, badge_data, points)
      apply SpecialBadgeCreated.new(data: {
        badge_id: @id,
        display_data:,
        badge_type:,
        badge_data:,
        points:,
      })
    end

    private

    on SpecialBadgeCreated do |event|
      @display_data = event.data[:display_data]
      @badge_type = event.data[:badge_type]
      @badge_data = event.data[:badge_data] 
      @points = event.data[:points]
    end
  end
end
