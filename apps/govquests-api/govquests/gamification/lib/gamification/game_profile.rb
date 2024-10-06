module Gamification
  class GameProfile
    include AggregateRoot

    def initialize(id)
      @id = id
      @score = 0
      @tier = nil
      @track = nil
      @streak = 0
      @badges = []
    end

    def update_score(points)
      apply ScoreUpdated.new(data: {
        profile_id: @id,
        points: points
      })
    end

    def achieve_tier(tier)
      apply TierAchieved.new(data: {
        profile_id: @id,
        tier: tier
      })
    end

    def complete_track(track)
      apply TrackCompleted.new(data: {
        profile_id: @id,
        track: track
      })
    end

    def maintain_streak(streak)
      apply StreakMaintained.new(data: {
        profile_id: @id,
        streak: streak
      })
    end

    def earn_badge(badge)
      apply BadgeEarned.new(data: {
        profile_id: @id,
        badge: badge
      })
    end

    private

    on ScoreUpdated do |event|
      @score += event.data[:points]
    end

    on TierAchieved do |event|
      @tier = event.data[:tier]
    end

    on TrackCompleted do |event|
      @track = event.data[:track]
    end

    on StreakMaintained do |event|
      @streak = event.data[:streak]
    end

    on BadgeEarned do |event|
      @badges << event.data[:badge]
    end
  end
end
