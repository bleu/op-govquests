module Processes
  class CreateBadgeOnTrackOrQuestCreated
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Questing::QuestCreated, ::Questing::TrackCreated])
    end

    def call(event)
      display_data = event.data[:badge_display_data]

      entity_type = event.class.name.split('::').last.gsub('Created', '')
      entity_id = event.data["#{entity_type.downcase}_id".to_sym]

      badge_id = Gamification.generate_badge_id(entity_type, entity_id)

      @command_bus.call(
        ::Gamification::CreateBadge.new(
          badge_id:,
          display_data:,
          badgeable_id: entity_id,
          badgeable_type: entity_type
        )
      )
    end
  end
end
