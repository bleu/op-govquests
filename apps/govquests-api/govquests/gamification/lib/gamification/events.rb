require_relative "types/claim_metadata"

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
    attribute :user_address, Infra::Types::String
    attribute :amount, Infra::Types::Integer
    attribute :claim_metadata, Infra::Types::Hash
    attribute :started_at, Infra::Types::Time
  end

  class TokenClaimCompleted < Infra::Event
    attribute :profile_id, Infra::Types::UUID
    attribute :token_address, Infra::Types::String
    attribute :user_address, Infra::Types::String
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
  
  class LeaderboardUpdated < Infra::Event
    attribute :leaderboard_id, Infra::Types::UUID
    attribute :profile_id, Infra::Types::UUID
    attribute :score, Infra::Types::Integer
  end

  class BadgeCreated < Infra::Event
    attribute :badge_id, Infra::Types::String
    attribute :display_data, Infra::Types::Hash
    attribute :badgeable_id, Infra::Types::UUID
    attribute :badgeable_type, Infra::Types::String
  end

  class BadgeEarned < Infra::Event
    attribute :user_id, Infra::Types::UUID
    attribute :badge_id, Infra::Types::String
    attribute :badge_type, Infra::Types::String
    attribute :earned_at, Infra::Types::DateTime
  end

  class SpecialBadgeCreated < Infra::Event
    attribute :badge_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash
    attribute :badge_type, Infra::Types::String
    attribute :badge_data, Infra::Types::Hash
  end

  class RewardPoolAssociated < Infra::Event
    attribute :badge_id, Infra::Types::UUID
    attribute :pool_id, Infra::Types::String
    attribute :reward_definition, Infra::Types::Hash
  end
end
