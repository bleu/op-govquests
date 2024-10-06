module ActionTracking
  class ActionExecutionService
    def self.start(action_id:, user_id:, data:)
      action = ActionTracking::ActionReadModel.find_by(action_id: action_id)
      return {error: "Action not found"} unless action

      execution_id = SecureRandom.uuid
      command = ActionTracking::StartActionExecution.new(
        execution_id: execution_id,
        action_id: action.action_id,
        user_id: user_id,
        data: data.to_h
      )
      Rails.configuration.command_bus.call(command)

      execution = ActionTracking::ActionExecutionReadModel.find_by(execution_id: execution_id)

      {salt: execution.salt, execution_id: execution_id, expires_at: execution.started_at + ActionExecution::EXPIRATION_TIME_IN_SECONDS}
    end

    def self.complete(execution_id:, salt:, user_id:, data:)
      execution = ActionTracking::ActionExecutionReadModel.find_by(execution_id: execution_id)
      return {error: "Execution not found"} unless execution
      return {error: "Invalid execution attempt"} unless execution.user_id == user_id

      command = ActionTracking::CompleteActionExecution.new(
        execution_id: execution.execution_id,
        salt: salt,
        data: data
      )

      begin
        Rails.configuration.command_bus.call(command)
        {message: "Action completed successfully"}
      rescue ActionExecution::InvalidSaltError
        {error: "Invalid salt"}
      rescue ActionExecution::NotStartedError
        {error: "Execution not started"}
      rescue ActionExecution::AlreadyCompletedError
        {error: "Execution already completed"}
      rescue ActionExecution::ExecutionExpiredError
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
