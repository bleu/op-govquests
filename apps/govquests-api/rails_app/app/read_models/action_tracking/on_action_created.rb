module ActionTracking
  class OnActionCreated
    def call(event)
      action = ActionReadModel.create!(
        action_id: event.data[:action_id],
        content: event.data[:content],
        action_type: event.data[:action_type],
        completion_criteria: event.data[:completion_criteria]
      )
      Rails.logger.info "Action created in read model: #{action.action_id}"
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Failed to create action in read model: #{e.message}"
    end
  end
end
