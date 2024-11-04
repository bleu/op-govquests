module ActionTracking
  class ActionExecutionService
    def self.start(quest_id:, action_id:, user_id:, start_data:, action_type:)
      action = ActionTracking::ActionReadModel.find_by(action_id: action_id)
      return {error: "Action not found"} unless action

      execution_id = ActionTracking.generate_execution_id(quest_id, action_id, user_id)

      nonce = SecureRandom.hex(16)
      strategy = ActionTracking::ActionExecutionStrategyFactory.for(action_type, start_data:)
      data = strategy.start_execution

      command = ActionTracking::StartActionExecution.new(
        quest_id: quest_id,
        execution_id: execution_id,
        action_id: action_id,
        user_id: user_id,
        start_data: data.merge(start_data || {}),
        nonce:
      )
      ActiveRecord::Base.transaction do
        Rails.configuration.command_bus.call(command)

        if ActionTracking::ActionExecutionStrategyFactory.for(action_type, start_data: data.merge(start_data || {})).complete_execution(dry_run: true)
          return complete(execution_id: execution_id, nonce: nonce, user_id: user_id, completion_data: {}, action_type:)
        end
      end

      ActionTracking::ActionExecutionReadModel.find_by(execution_id: execution_id)
    end

    def self.complete(execution_id:, nonce:, user_id:, completion_data:, action_type:)
      action_execution = ActionTracking::ActionExecutionReadModel.find_by(execution_id: execution_id)

      return {error: "Execution not started"} unless action_execution

      strategy = ActionTracking::ActionExecutionStrategyFactory.for(action_type, start_data: action_execution.start_data, completion_data:)
      data = strategy.complete_execution

      command = ActionTracking::CompleteActionExecution.new(
        execution_id: execution_id,
        nonce: nonce,
        completion_data: data.merge(completion_data || {})
      )

      begin
        Rails.configuration.command_bus.call(command)
      rescue ActionTracking::ActionExecution::InvalidNonceError
        {error: "Invalid nonce"}
      rescue ActionTracking::ActionExecution::NotStartedError
        {error: "Execution not started"}
      rescue ActionTracking::ActionExecution::AlreadyCompletedError
        {error: "Execution already completed"}
      rescue ActionTracking::ActionExecution::NotCompletedError => e
        {error: e.message}
      rescue ActionTracking::Strategies::Base::CompletionDataVerificationFailed => e
        {error: e.message}
      else
        ActionTracking::ActionExecutionReadModel.find_by(execution_id: execution_id)
      end
    end
  end
end
