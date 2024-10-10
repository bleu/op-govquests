module Processes
  class UpdateQuestProgressOnActionExecutionCompleted
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::ActionTracking::ActionExecutionCompleted])
    end

    def call(event)
      execution_id = event.data[:execution_id]
      action_execution = reconstruct_action_execution(execution_id)
      return unless action_execution

      quest_id = action_execution.quest_id
      action_id = action_execution.action_id
      user_id = action_execution.user_id
      completion_data = event.data[:completion_data] || {}

      user_quest_id = Questing.generate_user_quest_id(quest_id, user_id)

      command = ::Questing::UpdateUserQuestProgress.new(
        user_quest_id: user_quest_id,
        action_id: action_id,
        data: completion_data
      )

      @command_bus.call(command)
    end

    private

    def reconstruct_action_execution(execution_id)
      stream_name = "ActionExecution$#{execution_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      action_execution = OpenStruct.new
      events.each do |event|
        case event
        when ::ActionTracking::ActionExecutionStarted
          action_execution.quest_id = event.data[:quest_id]
          action_execution.action_id = event.data[:action_id]
          action_execution.user_id = event.data[:user_id]
        end
      end
      action_execution
    end
  end
end
