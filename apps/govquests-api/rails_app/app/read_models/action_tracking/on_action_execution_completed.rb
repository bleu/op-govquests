module ActionTracking
  class OnActionExecutionCompleted
    def call(event)
      execution = ActionExecutionReadModel.find_by(execution_id: event.data[:execution_id])
      if execution
        execution.update!(
          status: "completed",
          completion_data: event.data[:completion_data],
          completed_at: event.data[:timestamp]
        )
        Rails.logger.info "Action execution completed: #{event.data[:execution_id]}"
      else
        Rails.logger.error "Action execution not found: #{event.data[:execution_id]}"
      end
    end
  end
end
