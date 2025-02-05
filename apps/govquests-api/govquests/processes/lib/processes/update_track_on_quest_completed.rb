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
      quest_id = event.data[:quest_id]
      quest = reconstruct_quest(quest_id)

      track_id = quest.track_id
      user_id = event.data[:user_id]

      user_track_id = Questing.generate_user_track_id(track_id, user_id)

      @command_bus.call(
        Questing::UpdateUserTrackProgress.new(
          user_track_id:,
          quest_id:
        )
      )
    end

    private

    def reconstruct_quest(quest_id)
      stream_name = "Questing::Quest$#{quest_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      quest = OpenStruct.new(track_id: nil)

      events.each do |event|
        case event
        when ::Questing::QuestAssociatedWithTrack
          quest.track_id = event.data[:track_id]
        end
      end

      quest
    end
  end
end