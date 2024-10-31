module Gamification
  class ReadModelConfiguration
    def call(event_store)
      # event_store.subscribe(OnTierAchieved, to: [Gamification::TierAchieved])
      event_store.subscribe(OnTrackCompleted, to: [Gamification::TrackCompleted])
      event_store.subscribe(OnStreakMaintained, to: [Gamification::StreakMaintained])
      event_store.subscribe(OnBadgeEarned, to: [Gamification::BadgeEarned])
      event_store.subscribe(OnLeaderboardUpdated, to: [Gamification::LeaderboardUpdated])
      event_store.subscribe(OnScoreUpdated, to: [Gamification::ScoreUpdated])
    end
  end
end
