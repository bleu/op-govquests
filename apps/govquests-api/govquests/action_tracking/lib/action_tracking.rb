require "active_support/core_ext/digest/uuid"
require "active_support/core_ext/string/inflections"
require "infra"

module ActionTracking
  class << self
    def generate_execution_id(quest_id, action_id, user_id)
      name = "Quest$#{quest_id}-Action$#{action_id}-User$#{user_id}"
      namespace_uuid = ACTION_EXECUTION_NAMESPACE_UUID
      Digest::UUID.uuid_v5(namespace_uuid, name)
    end

    attr_accessor :event_store, :command_bus
  end
end

ACTION_EXECUTION_NAMESPACE_UUID = "061d2578-e3b3-41c0-b51d-b75b70876e71".freeze

require_relative "action_tracking/commands"
require_relative "action_tracking/events"

require_relative "action_tracking/action"
require_relative "action_tracking/action_execution"

require_relative "action_tracking/strategies/base"
require_relative "action_tracking/strategies/action_execution_strategy_factory"

# Load all strategy implementations
Dir[File.join(__dir__, "action_tracking/strategies/*.rb")].each do |f|
  next if f.end_with?("base.rb") # Skip base.rb as it's already required
  next if f.end_with?("action_execution_strategy_factory.rb") # Skip factory as it's already required
  require_relative f
end

module ActionTracking
  class CommandHandler < Infra::CommandHandlerRegistry
    handle "ActionTracking::CreateAction", aggregate: Action do |action, cmd|
      action.create(cmd.action_type, cmd.action_data, cmd.display_data)
    end

    handle "ActionTracking::StartActionExecution", aggregate: ActionExecution do |execution, cmd, repository|
      repository.with_aggregate(Action, cmd.action_id) do |action|
        action_type = action.action_type
        execution.start(
          cmd.quest_id,
          cmd.action_id,
          action_type,
          cmd.user_id,
          cmd.start_data,
          cmd.nonce
        )
      end
    end

    handle "ActionTracking::CompleteActionExecution", aggregate: ActionExecution do |execution, cmd|
      execution.complete(cmd.nonce, cmd.completion_data)
    end

    handle "ActionTracking::UpdateAction", aggregate: Action do |action, cmd|
      action.update(cmd.action_data, cmd.display_data)
    end
  end

  class Configuration
    def call(event_store, command_bus)
      CommandHandler.register_commands(event_store, command_bus)
    end
  end
end
