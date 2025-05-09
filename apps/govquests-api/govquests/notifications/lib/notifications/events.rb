module Notifications
  class NotificationCreated < Infra::Event
    attribute :notification_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :content, Infra::Types::String
    attribute :cta_text, Infra::Types::String.optional
    attribute :cta_url, Infra::Types::String.optional
    attribute :notification_type, Infra::Types::String
    attribute :delivery_methods, Infra::Types::Array.of(Infra::Types::String)
  end

  class NotificationDelivered < Infra::Event
    attribute :notification_id, Infra::Types::UUID
    attribute :delivery_method, Infra::Types::String
    attribute :delivered_at, Infra::Types::Time
    attribute :metadata, Infra::Types::Hash
  end

  class NotificationMarkedAsRead < Infra::Event
    attribute :notification_id, Infra::Types::UUID
    attribute :delivery_method, Infra::Types::String
    attribute :read_at, Infra::Types::Time
  end
end
