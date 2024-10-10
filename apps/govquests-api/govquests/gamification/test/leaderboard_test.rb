require_relative "test_helper"

module Gamification
  class LeaderboardTest < Test
    cover "Gamification::Leaderboard"

    def setup
      super
      @leaderboard_id = SecureRandom.uuid
      @leaderboard = Leaderboard.new(@leaderboard_id)
    end

    def test_update_score_and_rank
      profile_id1 = SecureRandom.uuid
      profile_id2 = SecureRandom.uuid
      profile_id3 = SecureRandom.uuid

      @leaderboard.update_score(profile_id1, 300)
      @leaderboard.update_score(profile_id2, 500)
      @leaderboard.update_score(profile_id3, 300)

      events = @leaderboard.unpublished_events.to_a
      assert_equal 3, events.size
      assert_instance_of LeaderboardUpdated, events[0]
      assert_instance_of LeaderboardUpdated, events[1]
      assert_instance_of LeaderboardUpdated, events[2]
    end
  end
end
