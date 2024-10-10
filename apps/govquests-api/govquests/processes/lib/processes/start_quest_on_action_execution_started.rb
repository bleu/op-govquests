module Processes
  class StartQuestOnActionExecutionStarted
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
