module Processes
  class StartTrackOnActionExecutionStarted
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

      quest = reconstruct_quest(quest_id)
      track_id = quest.track_id

      user_track_id = Questing.generate_user_track_id(track_id, user_id)
      user_track_events = @event_store.read.stream("Questing::UserTrack$#{user_track_id}").to_a

      return if user_track_events.any? { |event| event.is_a?(Questing::TrackStarted) }

      command = ::Questing::StartUserTrack.new(
        user_track_id: user_track_id,
        track_id: track_id,
        user_id: user_id
      )

      @command_bus.call(command)
      Rails.logger.info "Dispatched StartUserTrack command: #{command.inspect}"
    end

    private

    def reconstruct_quest(quest_id)
      stream_name = "Questing::Quest$#{quest_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      quest = OpenStruct.new(reward_pools: [])

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
