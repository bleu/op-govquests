module Processes
  class TriggerPosthogOnBadgeEarned
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

      return if badge_type == "Gamification::BadgeReadModel"
      
      badge = reconstruct_special_badge(badge_id)
      badge_title = badge&.display_data&.dig("title") if badge

      PosthogTrackingService.track_event("special_badge_earned", {
        special_badge_id: badge_id,
        special_badge_title: badge_title,
        earned_at: event.data[:earned_at],
        points_awarded: badge&.points,
        op_tokens_awarded: badge&.token_reward,
        user_id: user_id,
        status: "earned"
      }, user_id)
    end

    private 

    def reconstruct_special_badge(badge_id)
      stream_name = "Gamification::SpecialBadge$#{badge_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      special_badge = OpenStruct.new(display_data: {}, token_reward: nil, points: nil)

      special_badge_created_event_name = "Gamification::SpecialBadgeCreated"
      reward_pool_associated_event_name = "Gamification::RewardPoolAssociated"

      events.each do |event|
        case event
        when special_badge_created_event_name.constantize
          special_badge.display_data = event.data[:display_data]
        when reward_pool_associated_event_name.constantize
          if event.data[:reward_definition][:type] == "Token"
            special_badge.token_reward = event.data[:reward_definition][:amount]
          end
          if event.data[:reward_definition][:type] == "Points"
            special_badge.points = event.data[:reward_definition][:amount]
          end
        end
      end

      special_badge
    end
  end
end
