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
      profile_id = event.data[:profile_id]
      badge = event.data[:badge]

      @command_bus.call(
        ::Notifications::CreateNotification.new(
          notification_id: SecureRandom.uuid,
          user_id: profile_id,
          content: "Congratulations! You've earned the #{badge} badge!",
          notification_type: "badge_earned"
        )
      )
    end
  end
end
