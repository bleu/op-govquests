module Processes
  class UpdateTrackOnQuestCompleted
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

      user_track_id = Questing.generate_user_track_id(track.track_id, user_id)

      @command_bus.call(
        Questing::UpdateUserTrackProgress.new(
          user_track_id: ,
          quest_id: event.data[:quest_id]
        )
      )
    end
  end
end