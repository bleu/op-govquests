module Notifications
  class NotificationReadModel < ActiveRecord
  end

  class Configuration
    def call(event_store, command_bus)
      event_store.subscribe(OnNotificationCreated, to: [ Notifications::NotificationCreated ])
    end
  end
end
