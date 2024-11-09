module Mutations
  class MarkNotificationAsRead < BaseMutation
    argument :notification_id, ID, required: true
    argument :delivery_method, String, required: false, default_value: "in_app"

    field :notification_delivery, Types::NotificationDeliveryType, null: true
    field :errors, [String], null: false

    def resolve(notification_id:, delivery_method:)
      notification = Notifications::NotificationReadModel.find_by(notification_id: notification_id)

      if notification && notification.user_id == context[:current_user].user_id
        # Find the specified delivery
        delivery = notification.deliveries.find_by(delivery_method: delivery_method)

        if delivery
          command = Notifications::MarkNotificationAsRead.new(
            notification_id: notification.notification_id,
            delivery_method: delivery_method
          )

          Rails.configuration.command_bus.call(command)

          {
            notification_delivery: delivery.reload,
            errors: []
          }
        else
          {
            notification_delivery: nil,
            errors: ["Delivery method not found for this notification"]
          }
        end
      else
        {
          notification_delivery: nil,
          errors: ["Notification not found or access denied"]
        }
      end
    end
  end
end
