require "test_helper"

module Gamification
  class OnLeaderboardUpdatedTest < ActiveSupport::TestCase
    def setup
      @handler = OnLeaderboardUpdated.new
      @leaderboard_id = SecureRandom.uuid
      @profile_id = SecureRandom.uuid
      @score = 1500

      @leaderboard = LeaderboardReadModel.create!(
        leaderboard_id: @leaderboard_id,
        name: "Top Players"
      )
    end

    test "updates leaderboard entry when handling LeaderboardUpdated event" do
      event = LeaderboardUpdated.new(data: {
        leaderboard_id: @leaderboard_id,
        profile_id: @profile_id,
        score: @score
      })

      assert_difference "LeaderboardEntryReadModel.count", 1 do
        @handler.call(event)
      end

      entry = LeaderboardEntryReadModel.find_by(
        leaderboard_id: @leaderboard_id,
        profile_id: @profile_id
      )
      assert_equal @score, entry.score
      assert_not_nil entry.rank
      assert_equal @leaderboard, entry.leaderboard
    end
  end
end
