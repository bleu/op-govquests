module Resolvers
  class FetchNotifications < BaseResolver
    type Types::NotificationType.connection_type, null: false

    argument :read_status, String, required: false, default_value: "all"
    argument :notification_types, [String], required: false, default_value: []

    def resolve(read_status:, notification_types:)
      notifications = context[:current_user]
        .notifications
        .joins(:deliveries)
        .where(notification_deliveries: {delivery_method: "in_app"})

      # Filter by read status
      case read_status
      when "read"
        notifications = notifications.where.not(notification_deliveries: {read_at: nil})
      when "unread"
        notifications = notifications.where(notification_deliveries: {read_at: nil})
      end

      # Filter by notification types if provided
      notifications = notifications.where(notification_type: notification_types) unless notification_types.empty?

      notifications.distinct.order(created_at: :desc)
    end
  end
end
