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
      stream_name = "UserQuest$#{user_quest_id}"

      if @repository.aggregate_exists?(stream_name)
        Rails.logger.info "User #{user_id} already has an active quest #{quest_id}."
        return
      end

      command = ::Questing::StartUserQuest.new(
        user_quest_id: user_quest_id,
        quest_id: quest_id,
        user_id: user_id
      )

      @command_bus.call(command)
      Rails.logger.info "Dispatched StartUserQuest command: #{command.inspect}"
    rescue => e
      Rails.logger.error "Error in StartQuestOnActionExecutionStarted: #{e.message}"
      raise
    end
  end
end
