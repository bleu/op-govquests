require "test_helper"

module Rewarding
  class OnRewardClaimedTest < ActiveSupport::TestCase
    def setup
      @handler = OnRewardClaimed.new
      @reward_id = SecureRandom.uuid
      @user_id = SecureRandom.uuid

      # Create a reward read model entry
      RewardReadModel.create!(
        reward_id: @reward_id,
        reward_type: "points",
        value: 100,
        delivery_status: "Issued",
        issued_to: @user_id,
        claimed: false
      )
    end

    test "updates reward status to claimed when handling RewardClaimed event" do
      event = RewardClaimed.new(data: {
        reward_id: @reward_id,
        user_id: @user_id
      })

      @handler.call(event)

      reward = RewardReadModel.find_by(reward_id: @reward_id)
      assert_equal true, reward.claimed
      assert_equal "Claimed", reward.delivery_status
    end
  end
end
