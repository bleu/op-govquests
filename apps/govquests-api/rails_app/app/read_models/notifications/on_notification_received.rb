module Notifications
  class OnNotificationReceived
    def call(event)
      notification_id = event.data.fetch(:notification_id)
      received_at = event.data.fetch(:received_at)

      notification = NotificationReadModel.find_by(notification_id: notification_id)
      notification&.update(received_at: received_at, status: "received")
    end
  end
end
