require_relative "strategies/reward_strategy_factory"
module Rewarding
  class RewardPool
    include AggregateRoot

    class InsufficientInventory < StandardError; end

    class AlreadyIssued < StandardError; end

    class NotIssued < StandardError; end

    class AlreadyStartedClaim < StandardError; end

    class AlreadyCreated < StandardError; end

    class ClaimNotStarted < StandardError; end

    class AlreadyClaimed < StandardError; end

    def initialize(id, strategy_factory: Rewarding::RewardStrategyFactory)
      @id = id
      @quest_id = nil
      @reward_definition = nil
      @remaining_inventory = 0
      @issued_rewards = {}
      @strategy_factory = strategy_factory
    end

    def create(quest_id:, reward_definition:, initial_inventory: nil)
      raise AlreadyCreated if @quest_id

      apply RewardPoolCreated.new(data: {
        pool_id: @id,
        quest_id: quest_id,
        reward_definition: reward_definition,
        initial_inventory: initial_inventory
      })
    end

    def issue_reward(user_id)
      raise NotIssued unless @reward_definition

      ensure_token_not_issued_to(user_id)
      ensure_strategy_exists_for(user_id)
      enforce_token_inventory!

      apply RewardIssued.new(data: {
        pool_id: @id,
        user_id: user_id,
        reward_definition: @reward_definition,
        issued_at: Time.now
      })

      enforce_auto_claim!(user_id)
    end

    def start_claim(user_id, claim_metadata = {})
      raise NotIssued unless @issued_rewards[user_id]
      raise AlreadyStartedClaim if @issued_rewards[user_id][:claim_started_at]
      strategy = build_strategy_for(user_id, claim_metadata)
      claim_metadata = strategy.prepare_claim || {}

      apply RewardClaimStarted.new(data: {
        pool_id: @id,
        user_id: user_id,
        reward_definition: @reward_definition,
        claim_started_at: Time.now,
        claim_metadata: claim_metadata
      })

      if strategy.auto_complete?
        complete_claim(user_id, claim_metadata)
      end
    end

    def complete_claim(user_id, claim_metadata = {})
      raise NotIssued unless @issued_rewards[user_id]
      raise ClaimNotStarted unless @issued_rewards[user_id][:claim_started_at]
      raise AlreadyClaimed if @issued_rewards[user_id][:claim_completed_at]

      strategy = build_strategy_for(user_id, claim_metadata)
      completion_metadata = strategy.complete_claim || {}

      apply RewardClaimCompleted.new(data: {
        pool_id: @id,
        user_id: user_id,
        reward_definition: @reward_definition,
        claim_completed_at: Time.now,
        claim_metadata: completion_metadata
      })
    end

    private

    def ensure_token_not_issued_to(user_id)
      raise AlreadyIssued if @issued_rewards[user_id] && @reward_definition["type"] == "Token"
    end

    def ensure_strategy_exists_for(user_id)
      build_strategy_for(user_id, {})
    end

    def enforce_token_inventory!
      return unless @reward_definition["type"] == "Token"

      raise InsufficientInventory if @remaining_inventory - @reward_definition["amount"] < 0
    end

    def enforce_auto_claim!(user_id)
      return unless @reward_definition["type"] == "Points"

      start_claim(user_id, {})
    end

    def build_strategy_for(user_id, claim_metadata)
      @strategy_factory.for(
        @reward_definition["type"],
        reward_definition: @reward_definition,
        user_id: user_id,
        claim_metadata: claim_metadata
      )
    end

    on RewardPoolCreated do |event|
      @quest_id = event.data[:quest_id]
      @reward_definition = event.data[:reward_definition]
      @remaining_inventory = event.data[:initial_inventory] if event.data[:initial_inventory]
    end

    on RewardIssued do |event|
      user_id = event.data[:user_id]
      @issued_rewards[user_id] = {
        issued_at: event.data[:issued_at],
        claim_started_at: nil,
        claim_completed_at: nil,
        claim_metadata: {}
      }
      @remaining_inventory -= @reward_definition["amount"] if @reward_definition["type"] == "Token"
    end

    on RewardClaimStarted do |event|
      user_id = event.data[:user_id]
      @issued_rewards[user_id][:claim_started_at] = event.data[:claim_started_at]
      @issued_rewards[user_id][:claim_metadata] = event.data[:claim_metadata]
    end

    on RewardClaimCompleted do |event|
      user_id = event.data[:user_id]
      @issued_rewards[user_id][:claim_completed_at] = event.data[:claim_completed_at]
      @issued_rewards[user_id][:claim_metadata].merge!(event.data[:claim_metadata])
    end
  end
end
