module Notifications
  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnNotificationCreated.new, to: [Notifications::NotificationCreated])
      event_store.subscribe(OnNotificationDelivered.new, to: [Notifications::NotificationDelivered])
    end
  end
end
