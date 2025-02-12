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
      
      badge = reconstruct_badge(badge_id, badge_type)
      badge_title = badge&.display_data&.dig("title") if badge

      @command_bus.call(
        ::Notifications::CreateNotification.new(
          notification_id: SecureRandom.uuid,
          user_id: ,
          content: "Congratulations! You've earned the <a href='/achievements?badgeId=#{badge_id}'>#{badge_title}</a> badge!",
          notification_type: "badge_earned"
        )
      )
    end

    private 

    def reconstruct_badge(badge_id, badge_type)
      entity_name = badge_type.split("::").last.gsub("ReadModel", "")
      stream_name = "Gamification::#{entity_name}$#{badge_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      badge = OpenStruct.new(display_data: {})

      badge_created_event_name = "Gamification::#{entity_name}Created"

      events.each do |event|
        case event
        when badge_created_event_name.constantize
          badge.display_data = event.data[:display_data]
        end
      end

      badge
    end
  end
end
