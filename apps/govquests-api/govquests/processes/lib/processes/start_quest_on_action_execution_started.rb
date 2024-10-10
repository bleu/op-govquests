module Processes
  class StartQuestOnActionExecutionStarted
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
      @processed_event_ids = {}
    end

    def subscribe
      @event_store.subscribe(self, to: [::ActionTracking::ActionExecutionStarted])
    end

    def call(event)
      return if event_already_processed?(event)

      event.data[:action_id]
      user_id = event.data[:user_id]
      quest_id = event.data[:quest_id]

      return unless quest_id

      existing_user_quest = ::Questing::UserQuestReadModel.find_by(quest_id: quest_id, user_id: user_id)

      unless existing_user_quest.nil? || existing_user_quest.state == "completed"
        Rails.logger.info "User #{user_id} already has an active quest #{quest_id}."
        return
      end

      user_quest_id = SecureRandom.uuid

      command = ::Questing::StartUserQuest.new(
        user_quest_id: user_quest_id,
        quest_id: quest_id,
        user_id: user_id
      )

      @command_bus.call(command)
      Rails.logger.info "Dispatched StartUserQuest command: #{command.inspect}"

      mark_event_as_processed(event)
    rescue => e
      Rails.logger.error "Error in StartQuestOnActionExecutionStarted: #{e.message}"
      raise
    end

    private

    def event_already_processed?(event)
      @processed_event_ids[event.event_id]
    end

    def mark_event_as_processed(event)
      @processed_event_ids[event.event_id] = true
    end
  end
end
