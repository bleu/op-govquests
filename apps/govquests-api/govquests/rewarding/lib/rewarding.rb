require "infra"
require_relative "rewarding/commands"
require_relative "rewarding/events"

require_relative "rewarding/reward_pool"

module Rewarding
  class Configuration
    def call(event_store, command_bus)
      CommandHandler.register_commands(event_store, command_bus)
    end
  end

  class CommandHandler < Infra::CommandHandlerRegistry
    handle "Rewarding::CreateRewardPool", aggregate: RewardPool do |pool, cmd|
      pool.create(
        quest_id: cmd.quest_id,
        reward_definition: cmd.reward_definition,
        initial_inventory: cmd.initial_inventory
      )
    end

    handle "Rewarding::IssueReward", aggregate: RewardPool do |pool, cmd|
      pool.issue_reward(cmd.user_id)
    end
  end
end
