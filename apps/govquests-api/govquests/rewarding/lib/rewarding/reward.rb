module Rewarding
  class Reward
    include AggregateRoot

    AlreadyClaimed = Class.new(StandardError)

    def initialize(id)
      @id = id
      @reward_type = nil
      @value = nil
      @expiry_date = nil
      @issued_to = nil
      @claimed = false
    end

    def create(reward_type, value, expiry_date = nil)
      apply RewardCreated.new(data: {
        reward_id: @id,
        reward_type: reward_type,
        value: value,
        expiry_date: expiry_date
      })
    end

    def issue(user_id)
      apply RewardIssued.new(data: {reward_id: @id, user_id: user_id})
    end

    def claim(user_id)
      raise AlreadyClaimed if @claimed
      apply RewardClaimed.new(data: {reward_id: @id, user_id: user_id})
    end

    private

    on RewardCreated do |event|
      @reward_type = event.data[:reward_type]
      @value = event.data[:value]
      @expiry_date = event.data[:expiry_date]
    end

    on RewardIssued do |event|
      @issued_to = event.data[:user_id]
    end

    on RewardClaimed do |event|
      @claimed = true
    end
  end
end
