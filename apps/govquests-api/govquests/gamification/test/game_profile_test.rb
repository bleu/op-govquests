require_relative "test_helper"

module Gamification
  class GameProfileTest < Test
    cover "Gamification::GameProfile"

    def setup
      super
      @profile_id = SecureRandom.uuid
      @profile = GameProfile.new(@profile_id)
    end

    def test_update_score
      points = 100

      @profile.update_score(points)

      events = @profile.unpublished_events.to_a
      assert_equal 1, events.size
      event = events.first
      assert_instance_of ScoreUpdated, event
      assert_equal @profile_id, event.data[:profile_id]
      assert_equal points, event.data[:points]
    end

    def test_achieve_tier
      tier = "Gold"

      @profile.achieve_tier(tier)

      events = @profile.unpublished_events.to_a
      assert_equal 1, events.size
      event = events.first
      assert_instance_of TierAchieved, event
      assert_equal @profile_id, event.data[:profile_id]
      assert_equal tier, event.data[:tier]
    end
  end
end
