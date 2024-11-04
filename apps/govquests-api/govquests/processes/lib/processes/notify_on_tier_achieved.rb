module Processes
  class NotifyOnTierAchieved
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Gamification::TierAchieved])
    end

    def call(event)
      profile_id = event.data[:profile_id]
      tier = event.data[:tier]

      @command_bus.call(
        ::Notifications::CreateNotification.new(
          notification_id: SecureRandom.uuid,
          user_id: profile_id,
          content: "Congratulations! You've reached #{tier} tier!",
          notification_type: "tier_achieved"
        )
      )
    end
  end
end
