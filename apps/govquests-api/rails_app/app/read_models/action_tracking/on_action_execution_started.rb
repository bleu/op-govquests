module ActionTracking
  class OnActionExecutionStarted
    def call(event)
      ActionExecutionReadModel.create!(
        execution_id: event.data[:execution_id],
        action_id: event.data[:action_id],
        user_id: event.data[:user_id],
        quest_id: event.data[:quest_id],
        action_type: event.data[:action_type],
        started_at: event.data[:started_at],
        status: "started",
        start_data: event.data[:start_data],
        nonce: event.data[:nonce]
      )

      Rails.logger.info "Action execution started: #{event.data[:execution_id]}"
    end
  end
end
