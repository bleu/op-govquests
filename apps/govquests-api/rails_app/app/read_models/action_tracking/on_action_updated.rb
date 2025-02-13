module ActionTracking
  class OnActionUpdated
    def call(event)
      action = ActionReadModel.find_by(
        action_id: event.data[:action_id]
      )

      action.update!(
        action_data: event.data[:action_data],
        display_data: event.data[:display_data]
      )
      Rails.logger.info "Action updated in read model: #{event.data[:action_id]}"
    end
  end
end
