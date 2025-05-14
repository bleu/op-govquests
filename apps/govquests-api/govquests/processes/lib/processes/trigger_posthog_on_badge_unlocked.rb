
module Processes
  class TriggerPosthogOnBadgeUnlocked
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Gamification::BadgeUnlocked])
    end

    def call(event)
      badge = reconstruct_special_badge(event.data[:badge_id])

      PosthogTrackingService.track_event("special_badge_unlocked", {
        special_badge_id: event.data[:badge_id],
        special_badge_title: badge.display_data.dig("title"),
        user_id: event.data[:user_id],
        status: "unlocked"
      }, event.data[:user_id])
    end

    private
    
    def reconstruct_special_badge(badge_id)
      stream_name = "Gamification::SpecialBadge$#{badge_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      badge = OpenStruct.new(display_data: {})

      created_event_name = "Gamification::SpecialBadgeCreated"

      events.each do |event|
        case event
        when created_event_name.constantize
          badge.display_data = event.data[:display_data]
        end
      end

      badge
    end
  end
end
