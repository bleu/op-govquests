module Gamification
  class Badge
    include AggregateRoot

    def initialize(id)
      @id = id
      @display_data = nil
    end

    def create(display_data, badgeable_id, badgeable_type)
      apply BadgeCreated.new(data: {
        badge_id: @id,
        display_data:,
        badgeable_id:,
        badgeable_type:
      })
    end

    private

    on BadgeCreated do |event|
      @display_data = event.data[:display_data]
      @badgeable_id = event.data[:badgeable_id]
      @badgeable_type = event.data[:badgeable_type]
    end
  end
end
