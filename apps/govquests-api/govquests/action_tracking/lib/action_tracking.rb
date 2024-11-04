require "active_support/core_ext/digest/uuid"
require "infra"
require_relative "action_tracking/commands"
require_relative "action_tracking/events"
require_relative "action_tracking/on_action_commands"
require_relative "action_tracking/action"
require_relative "action_tracking/action_execution"
require_relative "action_tracking/strategies/action_execution_strategy_factory"
require_relative "action_tracking/strategies/gitcoin_score"
require_relative "action_tracking/strategies/read_document"
require_relative "action_tracking/strategies/ens"
require_relative "action_tracking/strategies/discourse_verification"
require_relative "action_tracking/strategies/send_email"
require_relative "action_tracking/strategies/wallet_verification"

ACTION_EXECUTION_NAMESPACE_UUID = "061d2578-e3b3-41c0-b51d-b75b70876e71".freeze

module ActionTracking
  class << self
    attr_accessor :event_store, :command_bus

    def generate_execution_id(quest_id, action_id, user_id)
      name = "Quest$#{quest_id}-Action$#{action_id}-User$#{user_id}"
      namespace_uuid = ACTION_EXECUTION_NAMESPACE_UUID
      Digest::UUID.uuid_v5(namespace_uuid, name)
    end
  end

  class Configuration
    def call(event_store, command_bus)
      ActionTracking.event_store = event_store
      ActionTracking.command_bus = command_bus

      ActionTracking::ActionExecutionStrategyFactory.register("gitcoin_score", ActionTracking::Strategies::GitcoinScore)
      ActionTracking::ActionExecutionStrategyFactory.register("read_document", ActionTracking::Strategies::ReadDocument)
      ActionTracking::ActionExecutionStrategyFactory.register("ens", ActionTracking::Strategies::Ens)
      ActionTracking::ActionExecutionStrategyFactory.register("discourse_verification", ActionTracking::Strategies::DiscourseVerification)
      ActionTracking::ActionExecutionStrategyFactory.register("send_email", ActionTracking::Strategies::SendEmail)
      ActionTracking::ActionExecutionStrategyFactory.register("wallet_verification", ActionTracking::Strategies::WalletVerification)

      command_handler = OnActionCommands.new(event_store)
      command_bus.register(ActionTracking::CreateAction, command_handler)
      command_bus.register(ActionTracking::StartActionExecution, command_handler)
      command_bus.register(ActionTracking::CompleteActionExecution, command_handler)
    end
  end
end
