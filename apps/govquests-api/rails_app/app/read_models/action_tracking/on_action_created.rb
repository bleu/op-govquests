module ActionTracking
  class OnActionCreated
    def call(event)
      action = ActionReadModel.find_or_initialize_by(
        action_id: event.data[:action_id]
      )

      action.update!(
        action_type: event.data[:action_type],
        action_data: event.data[:action_data],
        display_data: event.data[:display_data]
      )
      Rails.logger.info "Action created in read model: #{event.data[:action_id]}"
    end
  end
end
