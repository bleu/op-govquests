module Gamification
  class TokenRewardAdded < Infra::Event
    attribute :profile_id, Infra::Types::UUID
    attribute :token_address, Infra::Types::String
    attribute :amount, Infra::Types::Integer
    attribute :pool_id, Infra::Types::UUID
    attribute :total_unclaimed, Infra::Types::Integer
  end

  class TokenClaimStarted < Infra::Event
    attribute :profile_id, Infra::Types::UUID
    attribute :token_address, Infra::Types::String
    attribute :amount, Infra::Types::Integer
    attribute :claim_metadata, Infra::Types::Hash
    attribute :started_at, Infra::Types::Time
  end

  class TokenClaimCompleted < Infra::Event
    attribute :profile_id, Infra::Types::UUID
    attribute :token_address, Infra::Types::String
    attribute :amount, Infra::Types::Integer
    attribute :claim_metadata, Infra::Types::Hash
    attribute :completed_at, Infra::Types::Time
  end

  class ScoreUpdated < Infra::Event
    attribute :profile_id, Infra::Types::UUID
    attribute :points, Infra::Types::Integer
  end

  class TierAchieved < Infra::Event
    attribute :profile_id, Infra::Types::UUID
    attribute :tier, Infra::Types::String
  end

  class TrackCompleted < Infra::Event
    attribute :profile_id, Infra::Types::UUID
    attribute :track, Infra::Types::String
  end

  class StreakMaintained < Infra::Event
    attribute :profile_id, Infra::Types::UUID
    attribute :streak, Infra::Types::Integer
  end

  class BadgeEarned < Infra::Event
    attribute :profile_id, Infra::Types::UUID
    attribute :badge, Infra::Types::String
  end

  class LeaderboardUpdated < Infra::Event
    attribute :leaderboard_id, Infra::Types::UUID
    attribute :profile_id, Infra::Types::UUID
    attribute :score, Infra::Types::Integer
  end
end
