module Rewarding
  class RewardPool
    include AggregateRoot

    class AlreadyIssued < StandardError; end

    class NotIssued < StandardError; end

    class AlreadyCreated < StandardError; end

    class AlreadyConfirmed < StandardError; end

    def initialize(id)
      @id = id
      @rewardable_id = nil
      @rewardable_type = nil
      @reward_definition = nil
      @issued_rewards_receipients = Set.new
      @confirmed_token_transfer_receipients = Set.new
    end

    def create(rewardable_id:, rewardable_type:, reward_definition:)
      raise AlreadyCreated if @rewardable_id.present?
    
      apply RewardPoolCreated.new(data: {
        pool_id: @id,
        rewardable_id: rewardable_id,
        rewardable_type: rewardable_type,
        reward_definition: reward_definition
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

        Rewarding::RewardTokenService.call(
          pool_id: @id,
          amount: @reward_definition["amount"],
          user_id: user_id,
        )
      end

      apply RewardIssued.new(data: {
        pool_id: @id,
        user_id: user_id,
        reward_definition: @reward_definition,
        issued_at: Time.now
      })
    end

    def confirm_token_transfer(user_id, transaction_hash)
      raise NotIssued unless @issued_rewards_receipients.include?(user_id)
      raise AlreadyConfirmed if @confirmed_token_transfer_receipients.include?(user_id)

      apply TokenTransferConfirmed.new(data: {
        pool_id: @id,
        amount: @reward_definition["amount"],
        user_id: user_id,
        transaction_hash: transaction_hash,
        confirmed_at: Time.now
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
    end

    on RewardPoolUpdated do |event|
      @reward_definition = event.data[:reward_definition]
    end

    on RewardIssued do |event|
      @issued_rewards_receipients.add(event.data[:user_id])
    end

    on TokenTransferConfirmed do |event|
      @confirmed_token_transfer_receipients.add(event.data[:user_id])
    end
  end
end
