module Notifications
  class OnNotificationSent
    def call(event)
      notification_id = event.data.fetch(:notification_id)
      sent_at = event.data.fetch(:sent_at)

      notification = NotificationReadModel.find_by(notification_id: notification_id)
      notification.update!(sent_at: sent_at, status: "sent")
    end
  end
end
