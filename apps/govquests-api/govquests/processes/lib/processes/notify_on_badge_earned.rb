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
      
      badge = reconstruct_entity(badge_id, badge_type)
      badge_title = badge&.display_data&.dig("title") if badge

      notification_type = case badge_type
        when "Gamification::BadgeReadModel" then "badge_earned"
        when "Gamification::SpecialBadgeReadModel" then "special_badge_earned"
      end

      content = case notification_type
        when "badge_earned"
          "Congratulations! You've earned the <a href='/achievements?badgeId=#{badge_id}'>#{badge_title}</a> badge."
        when "special_badge_earned"
          "Congratulations! You've earned the <a href='/achievements?badgeId=#{badge_id}'>#{badge_title}</a> badge#{badge&.token_reward ? " and #{badge.token_reward} OP tokens for your efforts. You’ll be notified once the tokens are sent to your wallet" : ""}."
      end

      @command_bus.call(
        ::Notifications::CreateNotification.new(
          notification_id: SecureRandom.uuid,
          user_id: user_id,
          content: content,
          cta_text: nil,
          cta_url: nil,
          notification_type: notification_type,
          delivery_methods: ["email", "telegram", "in_app"]
        )
      )
    end

    private 

    def reconstruct_entity(entity_id, entity_type)
      entity_name = entity_type.split("::").last.gsub("ReadModel", "")
      stream_name = "Gamification::#{entity_name}$#{entity_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      entity = case entity_name
        when "Badge"
          reconstruct_badge(events)
        when "SpecialBadge"
          reconstruct_special_badge(events)
      end

      entity
    end

    def reconstruct_badge(events)
      badge = OpenStruct.new(display_data: {})

      badge_created_event_name = "Gamification::BadgeCreated"

      events.each do |event|
        case event
        when badge_created_event_name.constantize
          badge.display_data = event.data[:display_data]
        end
      end

      badge
    end

    def reconstruct_special_badge(events)
      special_badge = OpenStruct.new(display_data: {}, token_reward: nil)

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
        end
      end

      special_badge
    end
  end
end
