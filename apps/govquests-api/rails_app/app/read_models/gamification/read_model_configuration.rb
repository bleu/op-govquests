module Gamification
  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnBadgeCreated, to: [Gamification::BadgeCreated])
      event_store.subscribe(OnBadgeEarned, to: [Gamification::BadgeEarned])
      event_store.subscribe(OnBadgeUpdated, to: [Gamification::BadgeUpdated])
      event_store.subscribe(OnGameProfileCreated, to: [Gamification::GameProfileCreated])
      event_store.subscribe(OnGameProfileRankUpdated, to: [Gamification::GameProfileRankUpdated])
      event_store.subscribe(OnScoreUpdated, to: [Gamification::ScoreUpdated])
      event_store.subscribe(OnSpecialBadgeCreated, to: [Gamification::SpecialBadgeCreated])
      event_store.subscribe(OnSpecialBadgeUpdated, to: [Gamification::SpecialBadgeUpdated])
      event_store.subscribe(OnTierAchieved, to: [Gamification::TierAchieved])
      event_store.subscribe(OnTierCreated, to: [Gamification::TierCreated])
      event_store.subscribe(OnTierUpdated, to: [Gamification::TierUpdated])
      event_store.subscribe(OnVotingPowerUpdated, to: [Gamification::VotingPowerUpdated])
    end
  end
end
