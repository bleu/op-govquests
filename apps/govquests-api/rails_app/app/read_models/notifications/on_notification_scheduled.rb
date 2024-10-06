module Notifications
  class OnNotificationScheduled
    def call(event)
      notification_id = event.data.fetch(:notification_id)
      scheduled_time = event.data.fetch(:scheduled_time)

      notification = NotificationReadModel.find_by(notification_id: notification_id)
      notification&.update(scheduled_time: scheduled_time, status: "scheduled")
    end
  end
end
