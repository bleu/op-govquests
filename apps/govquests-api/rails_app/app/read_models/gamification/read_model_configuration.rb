module Gamification
  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnTierAchieved, to: [Gamification::TierAchieved])
      event_store.subscribe(OnVotingPowerUpdated, to: [Gamification::VotingPowerUpdated])
      event_store.subscribe(OnTrackCompleted, to: [Gamification::TrackCompleted])
      event_store.subscribe(OnStreakMaintained, to: [Gamification::StreakMaintained])
      event_store.subscribe(OnBadgeEarned, to: [Gamification::BadgeEarned])
      event_store.subscribe(OnLeaderboardUpdated, to: [Gamification::LeaderboardUpdated])
      event_store.subscribe(OnScoreUpdated, to: [Gamification::ScoreUpdated])
      event_store.subscribe(OnTokenRewardAdded, to: [Gamification::TokenRewardAdded])
      event_store.subscribe(OnTokenClaimStarted, to: [Gamification::TokenClaimStarted])
      event_store.subscribe(OnTokenClaimCompleted, to: [Gamification::TokenClaimCompleted])
      event_store.subscribe(OnBadgeCreated, to: [Gamification::BadgeCreated])
      event_store.subscribe(OnSpecialBadgeCreated, to: [Gamification::SpecialBadgeCreated])
      event_store.subscribe(OnTierCreated, to: [Gamification::TierCreated])
      event_store.subscribe(OnGameProfileCreated, to: [Gamification::GameProfileCreated])
      event_store.subscribe(OnBadgeUpdated, to: [Gamification::BadgeUpdated])
      event_store.subscribe(OnSpecialBadgeUpdated, to: [Gamification::SpecialBadgeUpdated])
      event_store.subscribe(OnTierUpdated, to: [Gamification::TierUpdated])
    end
  end
end
