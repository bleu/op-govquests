require "infra"
require_relative "rewarding/commands"
require_relative "rewarding/events"
require_relative "rewarding/on_reward_commands"
require_relative "rewarding/reward_pool"
require_relative "rewarding/strategies/token_reward"
require_relative "rewarding/strategies/points_reward"

module Rewarding
  class Configuration
    def call(event_store, command_bus)
      # safe_service = Rewarding::SafeService.new

      # Rewarding::RewardStrategyFactory.configure(
      #   safe_service: safe_service
      # )

      command_handler = OnRewardCommands.new(event_store)
      command_bus.register(CreateRewardPool, command_handler)
      command_bus.register(IssueReward, command_handler)
      command_bus.register(StartClaim, command_handler)
      command_bus.register(CompleteClaim, command_handler)
    end
  end
end
