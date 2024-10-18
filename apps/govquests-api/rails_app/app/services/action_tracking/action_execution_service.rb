module ActionTracking
  class ActionExecutionService
    def self.start(quest_id:, action_id:, user_id:, start_data:)
      action = ActionTracking::ActionReadModel.find_by(action_id: action_id)
      return {error: "Action not found"} unless action

      execution_id = ActionTracking.generate_execution_id(quest_id, action_id, user_id)
      command = ActionTracking::StartActionExecution.new(
        quest_id: quest_id,
        execution_id: execution_id,
        action_id: action_id,
        user_id: user_id,
        start_data: start_data.to_h
      )
      Rails.configuration.command_bus.call(command)

      ActionTracking::ActionExecutionReadModel.find_by(execution_id: execution_id)
    end

    def self.complete(execution_id:, nonce:, user_id:, completion_data:)
      command = ActionTracking::CompleteActionExecution.new(
        execution_id: execution_id,
        nonce: nonce,
        completion_data: completion_data
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
