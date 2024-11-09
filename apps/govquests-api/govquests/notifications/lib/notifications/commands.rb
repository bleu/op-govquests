module Notifications
  class CreateNotification < Infra::Command
    attribute :notification_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :content, Infra::Types::String
    attribute :notification_type, Infra::Types::String
    attribute :delivery_methods, Infra::Types::Array.of(Infra::Types::String).default(["in_app"].freeze)

    alias_method :aggregate_id, :notification_id
  end

  class DeliverNotification < Infra::Command
    attribute :notification_id, Infra::Types::UUID
    attribute :delivery_method, Infra::Types::String

    alias_method :aggregate_id, :notification_id
  end

  class MarkNotificationAsRead < Infra::Command
    attribute :notification_id, Infra::Types::UUID
    attribute :delivery_method, Infra::Types::String

    alias_method :aggregate_id, :notification_id
  end
end
