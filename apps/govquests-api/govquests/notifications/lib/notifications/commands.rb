module Notifications
  class CreateNotification < Infra::Command
    attribute :notification_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :content, Infra::Types::String
    attribute :notification_type, Infra::Types::String

    alias_method :aggregate_id, :notification_id
  end

  class SendNotification < Infra::Command
    attribute :notification_id, Infra::Types::UUID

    alias_method :aggregate_id, :notification_id
  end

  class MarkNotificationAsRead < Infra::Command
    attribute :notification_id, Infra::Types::UUID

    alias_method :aggregate_id, :notification_id
  end
end
