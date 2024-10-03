require "infra"
require_relative "action_tracking/commands"
require_relative "action_tracking/events"
require_relative "action_tracking/on_action_commands"
require_relative "action_tracking/action"

module ActionTracking
  class Configuration
    def call(event_store, command_bus)
      command_handler = OnActionCommands.new(event_store)
      command_bus.register(CreateAction, command_handler)
      command_bus.register(ExecuteAction, command_handler)
    end
  end
end
