module Processes
  class CompleteTrackOnQuestCompleted
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [Questing::QuestCompleted])
    end

    def call(event)
      quest = Questing::QuestReadModel.find_by(quest_id: event.data[:quest_id])
      return unless quest&.track_id

      track = quest.track
      user_id = event.data[:user_id]

      completed_quests_count = track.quests
        .joins(:user_quests)
        .where(
          user_quests: {
            user_id: user_id,
            status: "completed"
          }
        ).count

      if completed_quests_count == track.quests.count
        @command_bus.call(
          Questing::CompleteTrack.new(
            user_id: user_id,
            track_id: track.track_id
          )
        )
      end
    end
  end
end