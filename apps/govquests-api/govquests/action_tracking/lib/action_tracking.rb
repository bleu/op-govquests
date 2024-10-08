require "infra"
require_relative "action_tracking/commands"
require_relative "action_tracking/events"
require_relative "action_tracking/on_action_commands"
require_relative "action_tracking/action"
require_relative "action_tracking/action_execution"

ACTION_EXECUTION_NAMESPACE_UUID = "061d2578-e3b3-41c0-b51d-b75b70876e71".freeze

module ActionTracking
  class << self
    attr_accessor :event_store, :command_bus

    def generate_execution_id(action_id, user_id)
      name = "#{action_id}-#{user_id}"
      namespace_uuid = ACTION_EXECUTION_NAMESPACE_UUID
      Digest::UUID.uuid_v5(namespace_uuid, name)
    end
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
