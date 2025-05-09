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

      badge = badge(badge_id)
      badge_title = badge&.display_data&.dig("title") if badge

      @command_bus.call(
        ::Notifications::CreateNotification.new(
          notification_id: SecureRandom.uuid,
          user_id: user_id,
          content: "Congrats! You’ve met the criteria for the <a href='/achievements?badgeId=#{badge_id}'>#{badge_title}</a> badge. Celebrate your achievement and claim it now!",
          cta_text: "Claim Now",
          cta_url: "#{Rails.application.credentials.dig(Rails.env.to_sym, :frontend_domain)}/achievements?badgeId=#{badge_id}",
          notification_type: "badge_unlocked",
          delivery_methods: ["in_app", "email", "telegram"]
        )
      )
    end

    private

    def reconstruct_special_badge(badge_id)
      stream_name = "Gamification::SpecialBadge$#{badge_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      badge = OpenStruct.new(display_data: {})

      created_event_name = "Gamification::SpecialBadgeCreated"

      events.each do |event|
        case event
        when created_event_name.constantize
          badge.display_data = event.data[:display_data]
        end
      end

      badge
    end
  end
end
