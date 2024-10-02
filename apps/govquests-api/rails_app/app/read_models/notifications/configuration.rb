module Notifications
  class NotificationReadModel < ActiveRecord
  end

  class Configuration
    def call(event_store, command_bus)
      event_store.subscribe(CreateNotificationHandler, to: [Notifications::NotificationCreated])
      event_store.subscribe(ScheduleNotificationHandler, to: [Notifications::NotificationScheduled])
      event_store.subscribe(SendNotificationHandler, to: [Notifications::NotificationSent])
      event_store.subscribe(ReceiveNotificationHandler, to: [Notifications::NotificationReceived])
      event_store.subscribe(OpenNotificationHandler, to: [Notifications::NotificationOpened])
    end
  end
end
