module Processes
  class TriggerPosthogOnTierAchieved
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

      previous_tier_id = game_profile_previous_tier(profile_id)

      return if previous_tier_id.nil?

      old_tier_record = reconstruct_tier(previous_tier_id)
      old_tier_title = old_tier_record&.display_data&.dig("title") unless old_tier_record

      min_delegation = tier_record&.min_delegation
      old_min_delegation = old_tier_record&.min_delegation

      status = case min_delegation <=> old_min_delegation
        when 1 then "upgraded"
        when -1 then "downgraded"
      end
      
      PosthogTrackingService.track_event("tier_updated", {
        tier_id: tier_id,
        tier_title: tier_title,
        previous_tier_id: previous_tier_id,
        previous_tier_title: old_tier_title,
        user_id: profile_id,
        status: status
      }, profile_id)
    end

    private

    def game_profile_previous_tier(profile_id)
      stream_name = "Gamification::GameProfile$#{profile_id}"
      events = Rails.configuration.event_store.read.stream(stream_name).to_a

      return nil if events.empty?
      
      previous_tiers = events.find_all { |event| event.is_a?(Gamification::TierAchieved) }

      sorted_tiers = previous_tiers.sort_by { |event| event.metadata[:timestamp] }
      if sorted_tiers.length <= 1
        return nil
      end

      sorted_tiers[-2].data[:tier_id]
    end

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
