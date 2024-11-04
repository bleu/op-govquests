require "infra"
require_relative "notifications/commands"
require_relative "notifications/events"

require_relative "notifications/notification"

module Notifications
  class Configuration
    def call(event_store, command_bus)
      CommandHandler.register_commands(event_store, command_bus)
    end
  end

  class CommandHandler < Infra::CommandHandlerRegistry
    handle "Notifications::CreateNotification", aggregate: Notification do |notification, cmd|
      notification.create(cmd.user_id, cmd.content, cmd.notification_type)
    end

    handle "Notifications::DeliverNotification", aggregate: Notification do |notification, cmd|
      notification.deliver(cmd.delivery_method)
    end

    handle "Notifications::MarkNotificationAsRead", aggregate: Notification do |notification, cmd|
      notification.mark_as_read
    end
  end
end
