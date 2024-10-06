module ActionTracking
  class OnActionExecutionCompleted
    def call(event)
      execution = ActionExecutionReadModel.find_by(execution_id: event.data[:execution_id])
      if execution
        execution.update!(
          status: event.data[:result][:status],
          result: event.data[:result],
          completed_at: Time.current
        )
        Rails.logger.info "Action execution completed: #{event.data[:execution_id]}"
      else
        Rails.logger.error "Action execution not found: #{event.data[:execution_id]}"
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Failed to update action execution: #{e.message}"
    end
  end
end
