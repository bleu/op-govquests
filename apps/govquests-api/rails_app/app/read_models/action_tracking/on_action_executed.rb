module ActionTracking
  class OnActionExecuted
    def call(event)
      action_log_id = SecureRandom.uuid
      action_id = event.data[:action_id]
      user_id = event.data[:user_id]
      timestamp = event.data[:timestamp]
      status = "Executed"

      ActionLogReadModel.create!(
        action_log_id: action_log_id,
        action_id: action_id,
        user_id: user_id,
        executed_at: timestamp,
        status: status
      )
    end
  end
end
