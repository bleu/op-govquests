module Processes
  class NotifyOnBadgeEarned
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Gamification::BadgeEarned])
    end

    def call(event)
      user_id = event.data[:user_id]
      badge_id = event.data[:badge_id]
      badge_type = event.data[:badge_type]
      
      badge_record = badge_type.constantize.find_by(id: badge_id)
      badge_title = badge_record&.display_data&.dig("title") if badge_record

      @command_bus.call(
        ::Notifications::CreateNotification.new(
          notification_id: SecureRandom.uuid,
          user_id: ,
          content: "Congratulations! You've earned the #{badge_title} badge!",
          notification_type: "badge_earned"
        )
      )
    end
  end
end
