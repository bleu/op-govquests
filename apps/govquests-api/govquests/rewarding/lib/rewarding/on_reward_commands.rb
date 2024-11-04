module Rewarding
  class OnRewardCommands
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      case command
      when CreateRewardPool
        @repository.with_aggregate(RewardPool, command.aggregate_id) do |pool|
          pool.create(
            quest_id: command.quest_id,
            reward_definition: command.reward_definition,
            initial_inventory: command.initial_inventory
          )
        end
      when IssueReward
        @repository.with_aggregate(RewardPool, command.aggregate_id) do |pool|
          pool.issue_reward(command.user_id)
        end
      when StartClaim
        @repository.with_aggregate(RewardPool, command.pool_id) do |pool|
          pool.start_claim(command.user_id, command.claim_metadata)
        end
      when CompleteClaim
        @repository.with_aggregate(RewardPool, command.pool_id) do |pool|
          pool.complete_claim(
            command.user_id,
            command.claim_metadata
          )
        end
      end
    end
  end
end
