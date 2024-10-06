require "infra"
require_relative "action_tracking/commands"
require_relative "action_tracking/events"
require_relative "action_tracking/on_action_commands"
require_relative "action_tracking/action"
require_relative "action_tracking/action_execution"

module ActionTracking
  class << self
    attr_accessor :event_store, :command_bus
  end

  class Configuration
    def call(event_store, command_bus)
      ActionTracking.event_store = event_store
      ActionTracking.command_bus = command_bus

      command_handler = OnActionCommands.new(event_store)
      command_bus.register(ActionTracking::CreateAction, command_handler)
      command_bus.register(ActionTracking::StartActionExecution, command_handler)
      command_bus.register(ActionTracking::CompleteActionExecution, command_handler)
    end
  end
end
