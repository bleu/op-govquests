require "test_helper"

module Gamification
  class OnTierAchievedTest < ActiveSupport::TestCase
    def setup
      @handler = OnTierAchieved.new
      @profile_id = SecureRandom.uuid
      @game_profile = GameProfileReadModel.create!(profile_id: @profile_id, tier: "1", score: 100)
    end

    test "updates tier when handling TierAchieved event" do
      event = Gamification::TierAchieved.new(data: { profile_id: @profile_id, tier: "2" })
      @handler.call(event)

      @game_profile.reload
      assert_equal 2, @game_profile.tier
    end

    test "handles non-existent game profile gracefully" do
      non_existent_profile_id = SecureRandom.uuid
      event = Gamification::TierAchieved.new(data: { profile_id: non_existent_profile_id, tier: "2" })
      @handler.call(event)

      assert_nil GameProfileReadModel.find_by(profile_id: non_existent_profile_id)
    end
  end
end
