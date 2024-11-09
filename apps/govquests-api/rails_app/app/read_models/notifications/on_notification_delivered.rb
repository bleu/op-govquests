module Notifications
  class OnNotificationDelivered
    def call(event)
      delivery = NotificationDeliveryReadModel.find_by!(
        notification_id: event.data[:notification_id],
        delivery_method: event.data[:delivery_method]
      )

      delivery.update!(
        status: "delivered",
        delivered_at: event.data[:delivered_at],
        metadata: event.data[:metadata]
      )
    end
  end
end
