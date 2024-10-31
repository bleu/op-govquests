module Rewarding
  class RewardPool
    include AggregateRoot

    class InsufficientInventory < StandardError; end

    class AlreadyIssued < StandardError; end

    class NotIssued < StandardError; end

    class AlreadyClaimed < StandardError; end

    class AlreadyCreated < StandardError; end

    def initialize(id)
      @id = id
      @quest_id = nil
      @reward_definition = nil
      @remaining_inventory = 0
      @issued_rewards = {}
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
      if @reward_definition["type"] == "Token"
        check_token_reward_issuance(user_id)
      end

      apply RewardIssued.new(data: {
        pool_id: @id,
        user_id: user_id,
        reward_definition: @reward_definition,
        issued_at: Time.now
      })

      if @reward_definition["type"] == "Points"
        claim_reward(user_id)
      end
    end

    def claim_reward(user_id)
      raise NotIssued unless @issued_rewards[user_id]
      raise AlreadyClaimed if @issued_rewards[user_id][:claimed_at]

      apply RewardClaimed.new(data: {
        pool_id: @id,
        user_id: user_id,
        reward_definition: @reward_definition,
        claimed_at: Time.now
      })
    end

    private

    def check_token_reward_issuance(user_id)
      raise AlreadyIssued if @issued_rewards[user_id]
      raise InsufficientInventory if @remaining_inventory == 0
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
        claimed_at: nil
      }
      @remaining_inventory -= 1 if @reward_definition["type"] == "Token"
    end

    on RewardClaimed do |event|
      user_id = event.data[:user_id]
      @issued_rewards[user_id][:claimed_at] = event.data[:claimed_at]
    end
  end
end
