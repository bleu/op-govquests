module Processes
  class UpdateUserTypeOnTierAchieved
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

      min_delegation = tier_record&.min_delegation

      if min_delegation > 0
        @command_bus.call(
          Authentication::UpdateUserType.new(
            user_id: profile_id,
            user_type: "delegate"
          )
        )
      else
        @command_bus.call(
          Authentication::UpdateUserType.new(
            user_id: profile_id,
            user_type: "non_delegate"
          )
        )
      end
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
