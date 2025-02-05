module Processes
  class AddQuestToTrackOnQuestAssociated 
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Questing::QuestAssociatedWithTrack])
    end

    def call(event)
      quest_id = event.data[:quest_id]
      track_id = event.data[:track_id]

      @command_bus.call(
        ::Questing::AddQuestToTrack.new(
          quest_id:,
          track_id:
        )
      )
    end
  end
end
