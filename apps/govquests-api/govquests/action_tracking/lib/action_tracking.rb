require "active_support/core_ext/digest/uuid"
require "infra"
require_relative "action_tracking/commands"
require_relative "action_tracking/events"

require_relative "action_tracking/action"
require_relative "action_tracking/action_execution"
require_relative "action_tracking/strategies/action_execution_strategy_factory"
require_relative "action_tracking/strategies/gitcoin_score"
require_relative "action_tracking/strategies/read_document"
require_relative "action_tracking/strategies/ens"
require_relative "action_tracking/strategies/discourse_verification"
require_relative "action_tracking/strategies/send_email"
require_relative "action_tracking/strategies/verify_delegate"
require_relative "action_tracking/strategies/wallet_verification"
require_relative "action_tracking/strategies/verify_delegate_statement"
require_relative "action_tracking/strategies/verify_first_vote"

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
  end

  class Configuration
    def call(event_store, command_bus)
      CommandHandler.register_commands(event_store, command_bus)
      register_strategies
    end

    private

    def register_strategies
      ActionExecutionStrategyFactory.register("gitcoin_score", Strategies::GitcoinScore)
      ActionExecutionStrategyFactory.register("read_document", Strategies::ReadDocument)
      ActionExecutionStrategyFactory.register("ens", Strategies::Ens)
      ActionExecutionStrategyFactory.register("discourse_verification", Strategies::DiscourseVerification)
      ActionExecutionStrategyFactory.register("send_email", Strategies::SendEmail)
      ActionExecutionStrategyFactory.register("wallet_verification", Strategies::WalletVerification)
      ActionExecutionStrategyFactory.register("verify_delegate_statement", Strategies::VerifyDelegateStatement)
      ActionExecutionStrategyFactory.register("verify_delegate", Strategies::VerifyDelegate)
      ActionExecutionStrategyFactory.register("verify_first_vote", Strategies::VerifyFirstVote)
    end
  end
end
