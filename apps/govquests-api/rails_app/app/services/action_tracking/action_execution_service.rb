module ActionTracking
  class ActionExecutionService
    def self.start(action_id:, user_id:, start_data:)
      action = ActionTracking::ActionReadModel.find_by(action_id: action_id)
      return {error: "Action not found"} unless action

      execution_id = SecureRandom.uuid
      command = ActionTracking::StartActionExecution.new(
        execution_id: execution_id,
        action_id: action.action_id,
        user_id: user_id,
        start_data: start_data.to_h
      )
      Rails.configuration.command_bus.call(command)

      ActionTracking::ActionExecutionReadModel.find_by(execution_id: execution_id)
    end

    def self.complete(execution_id:, nonce:, user_id:, completion_data:)
      execution = ActionTracking::ActionExecutionReadModel.find_by(execution_id: execution_id)
      return {error: "Execution not found"} unless execution
      return {error: "Invalid execution attempt"} unless execution.user_id == user_id

      command = ActionTracking::CompleteActionExecution.new(
        execution_id: execution.execution_id,
        nonce: nonce,
        completion_data: completion_data.to_h
      )

      begin
        Rails.configuration.command_bus.call(command)
      rescue ActionTracking::ActionExecution::InvalidNonceError
        {error: "Invalid nonce"}
      rescue ActionTracking::ActionExecution::NotStartedError
        {error: "Execution not started"}
      rescue ActionTracking::ActionExecution::AlreadyCompletedError
        {error: "Execution already completed"}
      end

      ActionTracking::ActionExecutionReadModel.find_by(execution_id: execution_id)
    end
  end
end
