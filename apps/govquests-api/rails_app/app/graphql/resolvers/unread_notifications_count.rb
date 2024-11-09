module Resolvers
  class UnreadNotificationsCount < BaseResolver
    type Integer, null: false

    def resolve
      context[:current_user].notifications
        .joins(:deliveries)
        .where(notification_deliveries: {delivery_method: "in_app", read_at: nil})
        .distinct
        .count
    end
  end
end
