module Notifications
  class OnNotificationCreated
    def call(event)
      notification_id = event.data.fetch(:notification_id)
      content = event.data[:content]
      priority = event.data[:priority]
      channel = event.data[:channel]
      template_id = event.data[:template_id]

      NotificationReadModel.find_or_create_by(notification_id: notification_id).update(
        content: content,
        priority: priority,
        channel: channel,
        template_id: template_id,
        status: "Created"
      )
    end
  end
end
