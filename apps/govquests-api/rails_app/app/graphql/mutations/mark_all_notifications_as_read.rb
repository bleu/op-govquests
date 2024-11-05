module Mutations
  class MarkAllNotificationsAsRead < BaseMutation
    argument :delivery_method, String, required: false, default_value: "in_app"

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(delivery_method: "in_app")
      notifications = Notifications::NotificationReadModel
        .where(user_id: context[:current_user].user_id)
        .joins(:deliveries)
        .where(notification_deliveries: {
          delivery_method: delivery_method,
          read_at: nil
        })

      notifications.each do |notification|
        command = Notifications::MarkNotificationAsRead.new(
          notification_id: notification.notification_id,
          delivery_method: delivery_method
        )

        Rails.configuration.command_bus.call(command)
      end

      {
        success: true,
        errors: []
      }
    end
  end
end
