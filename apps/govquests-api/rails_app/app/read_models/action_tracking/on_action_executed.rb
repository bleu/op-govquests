module ActionTracking
  class OnActionExecuted
    def call(event)
      ActionLogReadModel.create!(
        action_log_id: SecureRandom.uuid,
        action_id: event.data[:action_id],
        user_id: event.data[:user_id],
        executed_at: event.data[:completion_data][:timestamp] || Time.current,
        completion_data: event.data[:completion_data],
        status: "Executed"
      )
      Rails.logger.info "Action executed and logged: #{event.data[:action_id]} by User #{event.data[:user_id]}"
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Failed to create action log: #{e.message}"
    end
  end
end
