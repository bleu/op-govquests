module Gamification
  class Badge
    include AggregateRoot

    class AlreadyCreated < StandardError; end

    def initialize(id)
      @id = id
      @display_data = nil
    end

    def create(display_data, badgeable_id, badgeable_type)
      raise AlreadyCreated if @display_data.present?
      apply BadgeCreated.new(data: {
        badge_id: @id,
        display_data:,
        badgeable_id:,
        badgeable_type:
      })
    end

    def update(display_data)
      apply BadgeUpdated.new(data: {
        badge_id: @id,
        display_data: display_data
      })
    end

    private

    on BadgeCreated do |event|
      @display_data = event.data[:display_data]
      @badgeable_id = event.data[:badgeable_id]
      @badgeable_type = event.data[:badgeable_type]
    end

    on BadgeUpdated do |event|
      @display_data = event.data[:display_data]
    end
  end
end
