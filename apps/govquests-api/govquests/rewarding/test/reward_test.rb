require_relative "test_helper"

module Rewarding
  class RewardTest < Test
    cover "Rewarding::Reward"

    def setup
      super
      @reward_id = SecureRandom.uuid
      @reward = Reward.new(@reward_id)
    end

    def test_create_a_new_reward
      reward_type = "points"
      value = 100
      expiry_date = Time.now + 30 * 24 * 60 * 60

      @reward.create(reward_type, value, expiry_date)

      events = @reward.unpublished_events.to_a
      assert_equal 1, events.size
      event = events.first
      assert_instance_of RewardCreated, event
      assert_equal @reward_id, event.data[:reward_id]
      assert_equal reward_type, event.data[:reward_type]
      assert_equal value, event.data[:value]
      assert_equal expiry_date, event.data[:expiry_date]
    end

    def test_issue_a_reward
      @reward.create("points", 100)
      user_id = SecureRandom.uuid

      @reward.issue(user_id)

      events = @reward.unpublished_events.to_a
      assert_equal 2, events.size
      event = events.last
      assert_instance_of RewardIssued, event
      assert_equal @reward_id, event.data[:reward_id]
      assert_equal user_id, event.data[:user_id]
    end

    def test_claim_a_reward
      @reward.create("points", 100)
      @reward.issue(SecureRandom.uuid)
      user_id = SecureRandom.uuid

      @reward.claim(user_id)

      events = @reward.unpublished_events.to_a
      assert_equal 3, events.size
      event = events.last
      assert_instance_of RewardClaimed, event
      assert_equal @reward_id, event.data[:reward_id]
      assert_equal user_id, event.data[:user_id]
    end

    def test_cannot_claim_an_already_claimed_reward
      @reward.create("points", 100)
      @reward.issue(SecureRandom.uuid)
      @reward.claim(SecureRandom.uuid)

      assert_raises(Reward::AlreadyClaimed) do
        @reward.claim(SecureRandom.uuid)
      end
    end
  end
end
