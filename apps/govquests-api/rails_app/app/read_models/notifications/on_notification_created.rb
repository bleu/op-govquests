module Notifications
  class OnNotificationCreated
    def call(event)
      notification_id = event.data.fetch(:notification_id)
      template_id = event.data.fetch(:template_id)
      user_id = event.data.fetch(:user_id)
      channel = event.data.fetch(:channel)
      priority = event.data.fetch(:priority)
      content = event.data[:content]
      notification_type = event.data[:notification_type]

      NotificationReadModel.find_or_create_by(notification_id: notification_id).update(
        template_id: template_id,
        user_id: user_id,
        channel: channel,
        priority: priority,
        content: content,
        notification_type: notification_type,
        status: "created"
      )
    end
  end
end
