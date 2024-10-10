module Rewarding
  class Reward
    include AggregateRoot

    class AlreadyClaimed < StandardError; end

    class NotIssued < StandardError; end

    class NotIssuedToUser < StandardError; end

    class NotCreated < StandardError; end

    def initialize(id)
      @id = id
      @created = false
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
      raise NotCreated unless @created

      apply RewardIssued.new(data: {reward_id: @id, user_id: user_id})
    end

    def claim(user_id)
      raise AlreadyClaimed if @claimed
      raise NotIssued if @issued_to.nil?
      raise NotIssuedToUser if @issued_to != user_id

      apply RewardClaimed.new(data: {reward_id: @id, user_id: user_id})
    end

    private

    on RewardCreated do |event|
      @created = true
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
