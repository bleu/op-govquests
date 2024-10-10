module Notifications
  class ReadModelConfiguration
    def call(event_store)
      # Notification Events
      event_store.subscribe(OnNotificationCreated, to: [Notifications::NotificationCreated])
      event_store.subscribe(OnNotificationScheduled, to: [Notifications::NotificationScheduled])
      event_store.subscribe(OnNotificationSent, to: [Notifications::NotificationSent])
      event_store.subscribe(OnNotificationReceived, to: [Notifications::NotificationReceived])
      event_store.subscribe(OnNotificationOpened, to: [Notifications::NotificationOpened])

      # NotificationTemplate Events
      event_store.subscribe(OnTemplateCreated, to: [Notifications::NotificationTemplateCreated])
      event_store.subscribe(OnTemplateUpdated, to: [Notifications::NotificationTemplateUpdated])
      event_store.subscribe(OnTemplateDeleted, to: [Notifications::NotificationTemplateDeleted])
    end
  end
end
