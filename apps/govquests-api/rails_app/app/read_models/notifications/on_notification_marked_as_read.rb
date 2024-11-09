module Notifications
  class OnNotificationMarkedAsRead
    def call(event)
      notification = NotificationReadModel.find_by(notification_id: event.data[:notification_id])
      delivery = notification.deliveries.find_by(delivery_method: event.data[:delivery_method])

      delivery.update!(read_at: event.data[:read_at])
    end
  end
end
