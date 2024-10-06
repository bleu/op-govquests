module Notifications
  class NotificationCreated < Infra::Event
    attribute :notification_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :content, Infra::Types::String
    attribute :notification_type, Infra::Types::String
  end

  class NotificationScheduled < Infra::Event
    attribute :notification_id, Infra::Types::UUID
    attribute :scheduled_time, Infra::Types::Time
  end

  class NotificationSent < Infra::Event
    attribute :notification_id, Infra::Types::UUID
    attribute :sent_at, Infra::Types::Time
  end

  class NotificationReceived < Infra::Event
    attribute :notification_id, Infra::Types::UUID
    attribute :received_at, Infra::Types::Time
  end

  class NotificationOpened < Infra::Event
    attribute :notification_id, Infra::Types::UUID
    attribute :opened_at, Infra::Types::Time
  end

  class NotificationMarkedAsRead < Infra::Event
    attribute :notification_id, Infra::Types::UUID
    attribute :read_at, Infra::Types::Time
  end
end
