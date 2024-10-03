require "test_helper"

module Gamification
  class OnBadgeEarnedTest < ActiveSupport::TestCase
    def setup
      @handler = OnBadgeEarned.new
      @profile_id = SecureRandom.uuid
      @badge = "Achiever"

      # Create a game profile read model entry
      GameProfileReadModel.create!(
        profile_id: @profile_id,
        badges: []
      )
    end

    test "adds a badge to game profile when handling BadgeEarned event" do
      event = BadgeEarned.new(data: {
        profile_id: @profile_id,
        badge: @badge
      })

      @handler.call(event)

      profile = GameProfileReadModel.find_by(profile_id: @profile_id)
      assert_includes profile.badges, @badge
    end

    test "does not duplicate badges in game profile" do
      profile = GameProfileReadModel.find_by(profile_id: @profile_id)
      profile.update(badges: [ @badge ])

      event = BadgeEarned.new(data: {
        profile_id: @profile_id,
        badge: @badge
      })

      @handler.call(event)

      profile.reload
      assert_equal 1, profile.badges.count(@badge)
    end
  end
end
