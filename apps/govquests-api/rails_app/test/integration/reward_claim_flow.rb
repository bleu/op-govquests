# rails_app/test/integration/reward_claim_flow_test.rb
require "test_helper"

class RewardClaimFlowTest < IntegrationTest
  test "issue and claim a reward" do
    # Setup: Create user and reward
    user_id = SecureRandom.uuid
    post "/register", params: {
      user_id: user_id,
      email: "user3@example.com",
      user_type: "non_delegate",
      wallet_address: "0xA1B2C3D4E5F6G7H8",
      chain_id: 1
    }
    assert_response :success

    reward_id = SecureRandom.uuid
    post "/rewards", params: {
      reward_id: reward_id,
      reward_type: "points",
      value: 100,
      expiry_date: (Time.current + 30.days).iso8601
    }
    assert_response :success
    assert_equal 1, RewardReadModel.count

    # Issue the reward to the user
    post "/rewards/#{reward_id}/issue", params: {user_id: user_id}
    assert_response :success
    reward = RewardReadModel.find_by(reward_id: reward_id)
    assert_not_nil reward
    assert_equal "Issued", reward.delivery_status
    assert_equal user_id, reward.issued_to

    # User claims the reward
    post "/rewards/#{reward_id}/claim", params: {user_id: user_id}
    assert_response :success
    reward.reload
    assert_equal true, reward.claimed
    assert_equal "Claimed", reward.delivery_status

    # Attempt to claim again
    post "/rewards/#{reward_id}/claim", params: {user_id: user_id}
    assert_response :unprocessable_entity
    assert_equal "Claimed", reward.delivery_status
  end
end
