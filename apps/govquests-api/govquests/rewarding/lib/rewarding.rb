require "infra"
require_relative "rewarding/commands"
require_relative "rewarding/events"
require_relative "rewarding/on_reward_commands"
require_relative "rewarding/reward_pool"

module Rewarding
  class Configuration
    def call(event_store, command_bus)
      command_handler = OnRewardCommands.new(event_store)
      command_bus.register(CreateRewardPool, command_handler)
      command_bus.register(IssueReward, command_handler)
      command_bus.register(ClaimReward, command_handler)
    end
  end
end
