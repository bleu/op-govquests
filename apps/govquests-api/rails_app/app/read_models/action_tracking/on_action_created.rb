module ActionTracking
  class OnActionCreated
    def call(event)
      action = ActionReadModel.create!(
        action_id: event.data[:action_id],
        action_type: event.data[:action_type],
        completion_criteria: event.data[:completion_criteria],
        display_data: {
          content: event.data[:content],
          duration: event.data[:duration]
        }
      )
      Rails.logger.info "Action created in read model: #{action.action_id}"
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Failed to create action in read model: #{e.message}"
    end
  end
end