module Notifications
  class OnNotificationCreated
    def call(event)
      notification = NotificationReadModel.create!(
        notification_id: event.data[:notification_id],
        user_id: event.data[:user_id],
        content: event.data[:content],
        notification_type: event.data[:notification_type]
      )

      # Create delivery records for each method
      event.data[:delivery_methods].each do |method|
        notification.deliveries.create!(
          delivery_method: method,
          status: "pending"
        )
      end
    end
  end
end
