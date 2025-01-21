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

      source_name = event.class.name.split('::').last.gsub('Created', '')
      source_type = "::Questing::#{source_name}ReadModel"

      source_id_field = "#{source_name.downcase}_id".to_sym
      source_uuid = event.data[source_id_field]
      
      source_sequential_id = source_type.constantize.find_by(source_id_field => source_uuid).id

      display_data = event.data[:badge_display_data].merge({
        sequence_number: source_sequential_id
      })

      badge_id = Gamification.generate_badge_id(source_type, source_uuid)

      @command_bus.call(
        ::Gamification::CreateBadge.new(
          badge_id:,
          display_data:,
          badgeable_id: source_uuid,
          badgeable_type: source_name
        )
      )
    end
  end
end
