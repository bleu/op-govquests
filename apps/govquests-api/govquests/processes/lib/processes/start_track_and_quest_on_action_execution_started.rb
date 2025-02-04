module Processes
  class StartTrackAndQuestOnActionExecutionStarted
    QuestNotFound = Class.new(StandardError)
    TrackNotFound = Class.new(StandardError)

    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def subscribe
      @event_store.subscribe(self, to: [::ActionTracking::ActionExecutionStarted])
    end

    def call(event)
      user_id = event.data[:user_id]
      quest_id = event.data[:quest_id]
      return unless quest_id

      user_quest_id = Questing.generate_user_quest_id(quest_id, user_id)
      stream_name = "Questing::UserQuest$#{user_quest_id}"

      events = @event_store.read.stream(stream_name).to_a

      return if events.any? { |event| event.is_a?(Questing::QuestStarted) }

      quest = Questing::QuestReadModel.find_by(quest_id: quest_id)

      raise QuestNotFound, "Quest not found" unless quest
      raise TrackNotFound, "Track not found for quest" unless quest.track

      user_track_id = Questing.generate_user_track_id(quest.track.track_id, user_id)

      @command_bus.call(
        ::Questing::StartUserTrack.new(
          user_track_id: ,
          user_id: user_id, 
          track_id: quest.track.track_id
        )
      )

      command = ::Questing::StartUserQuest.new(
        user_quest_id: user_quest_id,
        quest_id: quest_id,
        user_id: user_id
      )

      @command_bus.call(command)
      Rails.logger.info "Dispatched StartUserQuest command: #{command.inspect}"
    end
  end
end
