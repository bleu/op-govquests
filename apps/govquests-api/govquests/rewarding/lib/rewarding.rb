require "infra"
require_relative "rewarding/commands"
require_relative "rewarding/events"

require_relative "rewarding/reward_pool"

REWARDING_NAMESPACE_UUID = "85b7f3c9-a3bc-4c16-bb5d-2c0bed8a6da7"

module Rewarding
  class << self
    def generate_reward_pool_id(rewardable_id, rewardable_type, reward)
      name = "#{rewardable_type}$#{rewardable_id}-#{reward[:type]}"
      namespace_uuid = REWARDING_NAMESPACE_UUID
      Digest::UUID.uuid_v5(namespace_uuid, name)
    end
  end

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
