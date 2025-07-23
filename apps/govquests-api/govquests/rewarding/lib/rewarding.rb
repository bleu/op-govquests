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
        rewardable_id: cmd.rewardable_id,
        rewardable_type: cmd.rewardable_type,
        reward_definition: cmd.reward_definition
      )
    end

    handle "Rewarding::IssueReward", aggregate: RewardPool do |pool, cmd|
      pool.issue_reward(cmd.user_id)
    end

    handle "Rewarding::UpdateRewardPool", aggregate: RewardPool do |pool, cmd|
      pool.update(cmd.reward_definition)
    end

    handle "Rewarding::ConfirmTokenTransfer", aggregate: RewardPool do |pool, cmd|
      pool.confirm_token_transfer(cmd.user_id, cmd.transaction_hash)
    end
  end
end
