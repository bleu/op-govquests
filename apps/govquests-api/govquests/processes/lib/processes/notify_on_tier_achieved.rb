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
      tier_id = event.data[:tier_id]

      tier_record = ::Gamification::TierReadModel.find_by(tier_id: tier_id)
      tier_name = tier_record&.display_data&.dig("name")

      @command_bus.call(
        ::Notifications::CreateNotification.new(
          notification_id: SecureRandom.uuid,
          user_id: profile_id,
          content: "Congratulations! You've reached #{tier_name} tier!",
          notification_type: "tier_achieved"
        )
      )
    end
  end
end
