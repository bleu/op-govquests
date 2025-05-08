module Types
  class NotificationType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    field :id, ID, null: false, method: :notification_id
    field :content, String, null: false
    field :notification_type, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false

    field :deliveries, Types::NotificationDeliveryType.connection_type, null: false

    field :status, String, null: false

    field :title, String, null: false

    def status
      in_app_delivery = object.deliveries.find_by(delivery_method: "in_app")
      if in_app_delivery&.read_at.present?
        "read"
      else
        "unread"
      end
    end
  end
end
