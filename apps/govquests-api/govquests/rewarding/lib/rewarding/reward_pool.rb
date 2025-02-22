module Rewarding
  class RewardPool
    include AggregateRoot

    class InsufficientInventory < StandardError; end

    class AlreadyIssued < StandardError; end

    class NotIssued < StandardError; end

    class AlreadyCreated < StandardError; end

    def initialize(id)
      @id = id
      @rewardable_id = nil
      @rewardable_type = nil
      @reward_definition = nil
      @remaining_inventory = 0
      @issued_rewards_receipients = Set.new
    end

    def create(rewardable_id:, rewardable_type:, reward_definition:, initial_inventory: nil)
      raise AlreadyCreated if @rewardable_id.present?
    
      apply RewardPoolCreated.new(data: {
        pool_id: @id,
        rewardable_id: rewardable_id,
        rewardable_type: rewardable_type,
        reward_definition: reward_definition,
        initial_inventory: initial_inventory
      })
    end

    def update(reward_definition)
      apply RewardPoolUpdated.new(data: {
        pool_id: @id,
        reward_definition: reward_definition
      })
    end

    def issue_reward(user_id)
      raise NotIssued unless @reward_definition

      if token_reward?
        raise AlreadyIssued if @issued_rewards_receipients.include?(user_id)
        raise InsufficientInventory if @remaining_inventory < @reward_definition["amount"]
      end

      apply RewardIssued.new(data: {
        pool_id: @id,
        user_id: user_id,
        reward_definition: @reward_definition,
        issued_at: Time.now
      })
    end

    private

    def token_reward?
      @reward_definition["type"] == "Token"
    end

    on RewardPoolCreated do |event|
      @rewardable_id = event.data[:rewardable_id]
      @rewardable_type = event.data[:rewardable_type]
      @reward_definition = event.data[:reward_definition]
      @remaining_inventory = event.data[:initial_inventory] if event.data[:initial_inventory]
    end

    on RewardPoolUpdated do |event|
      @reward_definition = event.data[:reward_definition]
    end

    on RewardIssued do |event|
      @issued_rewards_receipients.add(event.data[:user_id])

      if token_reward?
        @remaining_inventory -= @reward_definition["amount"]
      end
    end
  end
end
