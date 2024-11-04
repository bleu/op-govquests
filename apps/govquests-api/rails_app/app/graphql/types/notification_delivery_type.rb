module Types
  class NotificationDeliveryType < Types::BaseObject
    implements GraphQL::Types::Relay::Node
    field :id, ID, null: false, method: :notification_id
    field :delivery_method, String, null: false
    field :status, String, null: false
    field :delivered_at, GraphQL::Types::ISO8601DateTime, null: true
    field :read_at, GraphQL::Types::ISO8601DateTime, null: true
    field :metadata, GraphQL::Types::JSON, null: true

    def status
      if object.read_at.present?
        "read"
      else
        object.status
      end
    end
  end
end
