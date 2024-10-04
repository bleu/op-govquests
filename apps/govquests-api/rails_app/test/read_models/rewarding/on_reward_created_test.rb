require "test_helper"

module Rewarding
  class OnRewardCreatedTest < ActiveSupport::TestCase
    def setup
      @handler = OnRewardCreated.new
      @reward_id = SecureRandom.uuid
      @reward_type = "points"
      @value = 100
      @expiry_date = Time.current + 7.days
    end

    test "creates a new reward when handling RewardCreated event" do
      event = Rewarding::OnRewardCreated.new(data: {
        reward_id: @reward_id,
        reward_type: @reward_type,
        value: @value,
        expiry_date: @expiry_date
      })

      assert_difference "RewardReadModel.count", 1 do
        @handler.call(event)
      end

      reward = RewardReadModel.find_by(reward_id: @reward_id)
      assert_equal @reward_type, reward.reward_type
      assert_equal @value, reward.value
      assert_equal @expiry_date.to_i, reward.expiry_date.to_i
      assert_equal "Pending", reward.delivery_status
    end
  end
end
