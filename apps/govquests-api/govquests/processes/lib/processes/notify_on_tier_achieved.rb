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

      tier_record = reconstruct_tier(tier_id)
      tier_name = tier_record&.display_data&.dig("name") unless tier_record

      @command_bus.call(
        ::Notifications::CreateNotification.new(
          notification_id: SecureRandom.uuid,
          user_id: profile_id,
          content: "Level up! You've climbed to #{tier_name} tier!",
          notification_type: "tier_achieved"
        )
      )
    end

    private

    def reconstruct_tier(tier_id)
      stream_name = "Gamification::Tier$#{tier_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      tier = OpenStruct.new(display_data: {})

      tier_created_event_name = "Gamification::TierCreated"

      events.each do |event|
        case event
        when tier_created_event_name.constantize
          tier.display_data = event.data[:display_data]
        end
      end

      tier
    end
  end
end
