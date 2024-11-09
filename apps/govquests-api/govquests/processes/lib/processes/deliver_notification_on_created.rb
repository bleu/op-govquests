module Processes
  class DeliverNotificationOnCreated
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Notifications::NotificationCreated])
    end

    def call(event)
      notification_id = event.data[:notification_id]
      delivery_methods = event.data[:delivery_methods]

      delivery_methods.each do |method|
        @command_bus.call(
          ::Notifications::DeliverNotification.new(
            notification_id: notification_id,
            delivery_method: method
          )
        )
      end
    end
  end
end
