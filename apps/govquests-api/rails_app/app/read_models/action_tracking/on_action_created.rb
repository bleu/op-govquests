module ActionTracking
  class OnActionCreated
    def call(event)
      ActionReadModel.find_or_create_by(action_id: event.data[:action_id]).update(
        content: event.data[:content],
        priority: event.data[:priority],
        channel: event.data[:channel],
        status: "Created"
      )
    end
  end
end
