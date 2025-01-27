module Gamification
  class Tier
    include AggregateRoot

    def initialize(id)
      @id = id
      @display_data = nil
    end

    def create(display_data)
      apply TierCreated.new(data: {
        badge_id: @id,
        display_data:,
      })
    end

    private

    on TierCreated do |event|
      @display_data = event.data[:display_data]
    end
  end
end