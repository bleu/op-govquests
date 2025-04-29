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
      tier_title = tier_record&.display_data&.dig("title") unless tier_record

      return if event.data[:old_tier_id].nil?

      old_tier_record = reconstruct_tier(event.data[:old_tier_id])
      
      min_delegation = tier_record&.min_delegation
      old_min_delegation = old_tier_record&.min_delegation

      notification_type = case min_delegation <=> old_min_delegation
        when 1 then "tier_achieved"
        when -1 then "tier_downgraded"
      end

      content = case notification_type
        when "tier_achieved"
          "You’ve reached #{tier_title}! Keep up the amazing work and keep climbing!"
        when "tier_downgraded"
          "You’ve been moved to #{tier_title}. Don’t worry, keep completing quests to climb back up!"
      end

      @command_bus.call(
        ::Notifications::CreateNotification.new(
          notification_id: SecureRandom.uuid,
          user_id: profile_id,
          content: content,
          notification_type: notification_type
        )
      )
    end

    private

    def reconstruct_tier(tier_id)
      return nil if tier_id.nil?

      stream_name = "Gamification::Tier$#{tier_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      tier = OpenStruct.new(display_data: {})

      tier_created_event_name = "Gamification::TierCreated"

      events.each do |event|
        case event
        when tier_created_event_name.constantize
          tier.display_data = event.data[:display_data]
          tier.min_delegation = event.data[:min_delegation]
        end
      end

      tier
    end
  end
end
