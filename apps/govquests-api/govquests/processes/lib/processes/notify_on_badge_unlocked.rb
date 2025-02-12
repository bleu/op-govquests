module Processes
  class NotifyOnBadgeUnlocked
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Gamification::BadgeUnlocked])
    end

    def call(event)
      user_id = event.data[:user_id]
      badge_id = event.data[:badge_id]

      @command_bus.call(
        ::Notifications::CreateNotification.new(
          notification_id: SecureRandom.uuid,
          user_id: ,
          content: "New <a href='/achievements?badgeId=#{badge_id}'>badge</a> unlocked!",
          notification_type: "badge_unlocked"
        )
      ) if event.data[:notify]
    end
  end
end
