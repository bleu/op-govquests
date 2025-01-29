module Gamification
  class Tier
    include AggregateRoot

    def initialize(id)
      @id = id
      @display_data = nil
      @min_delegation = nil
      @max_delegation = nil
      @multiplier = 1.0
      @image_url = nil
    end

    def create(display_data, min_delegation, max_delegation, multiplier, image_url)
      apply TierCreated.new(data: {
        tier_id: @id,
        display_data:,
        min_delegation:,
        max_delegation:,
        multiplier:,
        image_url:,
      })
    end

    private

    on TierCreated do |event|
      @display_data = event.data[:display_data]
      @min_delegation = event.data[:min_delegation]
      @max_delegation = event.data[:max_delegation]
      @multiplier = event.data[:multiplier]
      @image_url = event.data[:image_url]
    end
  end
end