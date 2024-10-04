# rails_app/app/read_models/action_tracking/on_action_executed.rb
module ActionTracking
  class OnActionExecuted
    def call(event)
      action_log_id = SecureRandom.uuid
      action_id = event.data[:action_id]
      user_id = event.data[:user_id]
      timestamp = event.data[:timestamp]
      completion_data = event.data[:completion_data]
      status = "Executed"

      ActionLogReadModel.create!(
        action_log_id: action_log_id,
        action_id: action_id,
        user_id: user_id,
        executed_at: timestamp,
        completion_data: completion_data,
        status: status
      )
    end
  end
end
