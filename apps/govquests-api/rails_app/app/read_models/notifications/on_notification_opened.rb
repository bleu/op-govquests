module Notifications
  class OnNotificationOpened
    def call(event)
      notification_id = event.data.fetch(:notification_id)
      opened_at = event.data.fetch(:opened_at)

      notification = NotificationReadModel.find_by(notification_id: notification_id)
      notification.update(opened_at: opened_at, status: "opened") if notification
    end
  end
end
