require "infra"
require_relative "notifications/commands"
require_relative "notifications/events"
require_relative "notifications/template_commands"
require_relative "notifications/template_events"
require_relative "notifications/on_notification_commands"
require_relative "notifications/notification"

module Notifications
  class Configuration
    def call(event_store, command_bus)
      command_handler = OnNotificationCommands.new(event_store)
      command_bus.register(CreateNotification, command_handler)
      command_bus.register(SendNotification, command_handler)
      command_bus.register(MarkNotificationAsRead, command_handler)
    end
  end
end
