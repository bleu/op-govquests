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

      execution = ActionTracking::ActionExecutionReadModel.find_by(execution_id: execution_id)

      {nonce: execution.nonce, execution_id: execution_id, expires_at: execution.started_at + ActionTracking::ActionExecution::EXPIRATION_TIME_IN_SECONDS}
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
        {message: "Action completed successfully"}
      rescue ActionTracking::ActionExecution::InvalidNonceError
        {error: "Invalid nonce"}
      rescue ActionTracking::ActionExecution::NotStartedError
        {error: "Execution not started"}
      rescue ActionTracking::ActionExecution::AlreadyCompletedError
        {error: "Execution already completed"}
      rescue ActionTracking::ActionExecution::ExecutionExpiredError
        expire_execution(execution_id)
        {error: "Execution expired", message: "Please start a new execution"}
      end
    end

    private

    def self.expire_execution(execution_id)
      command = ActionTracking::ExpireActionExecution.new(execution_id: execution_id)
      Rails.configuration.command_bus.call(command)
    end
  end
end
