module Processes
  class RewardBadgeOnQuestCompleted
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Questing::QuestCompleted])
    end

    def call(event)
      user_id = event.data[:user_id]

      quest_id = event.data[:quest_id]
      quest = ::Questing::QuestReadModel.find_by(quest_id: quest_id)
      
      badge = Gamification::BadgeReadModel.find_by(
        badgeable_type: "Questing::QuestReadModel",
        badgeable_id: quest.id.to_s,
      )

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
