module Processes
  class RewardBadgeOnQuestOrTrackCompleted
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Questing::QuestCompleted, ::Questing::TrackCompleted])
    end

    def call(event)
      user_id = event.data[:user_id]

      entity_name = event.class.name.split('::').last.gsub('Completed', '')
      entity_type = case entity_name
        when 'Quest' then 'Questing::QuestReadModel'
        when 'Track' then 'Questing::TrackReadModel'
      end
      entity_id = event.data["#{entity_name.downcase}_id".to_sym]

      entity = entity_type.constantize.find_by("#{entity_name.downcase}_id": entity_id)

      badge = Gamification::BadgeReadModel.find_by(
        badgeable_type: entity_type,
        badgeable_id: entity.id.to_s,
      )

      return unless badge

      @command_bus.call(
        ::Gamification::EarnBadge.new(
          user_id:,
          badgeable_id: badge.id.to_s,
          badgeable_type: badge.class.name,
        )
      )
    end
  end
end
