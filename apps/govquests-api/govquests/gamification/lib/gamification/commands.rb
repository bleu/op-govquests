require_relative "types/claim_metadata"
module Gamification
  class AddTokenReward < Infra::Command
    attribute :profile_id, Infra::Types::UUID
    attribute :token_address, Infra::Types::String
    attribute :amount, Infra::Types::Integer
    attribute :pool_id, Infra::Types::UUID

    alias_method :aggregate_id, :profile_id
  end

  class StartTokenClaim < Infra::Command
    attribute :profile_id, Infra::Types::UUID
    attribute :token_address, Infra::Types::String
    attribute :user_address, Infra::Types::String

    alias_method :aggregate_id, :profile_id
  end

  class CompleteTokenClaim < Infra::Command
    attribute :profile_id, Infra::Types::UUID
    attribute :token_address, Infra::Types::String
    attribute :claim_metadata, Gamification::Types::ClaimMetadata

    alias_method :aggregate_id, :profile_id
  end

  class UpdateScore < Infra::Command
    attribute :profile_id, Infra::Types::UUID
    attribute :points, Infra::Types::Integer

    alias_method :aggregate_id, :profile_id
  end

  class AchieveTier < Infra::Command
    attribute :profile_id, Infra::Types::UUID
    attribute :tier, Infra::Types::String

    alias_method :aggregate_id, :profile_id
  end

  class CompleteTrack < Infra::Command
    attribute :profile_id, Infra::Types::UUID
    attribute :track, Infra::Types::String

    alias_method :aggregate_id, :profile_id
  end

  class MaintainStreak < Infra::Command
    attribute :profile_id, Infra::Types::UUID
    attribute :streak, Infra::Types::Integer

    alias_method :aggregate_id, :profile_id
  end

  class UpdateLeaderboard < Infra::Command
    attribute :leaderboard_id, Infra::Types::UUID
    attribute :profile_id, Infra::Types::UUID
    attribute :score, Infra::Types::Integer

    alias_method :aggregate_id, :leaderboard_id
  end

  class CreateBadge < Infra::Command
    attribute :badge_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash
    attribute :badgeable_id, Infra::Types::UUID
    attribute :badgeable_type, Infra::Types::String

    alias_method :aggregate_id, :badge_id
  end

  class EarnBadge < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :badgeable_id, Infra::Types::String
    attribute :badgeable_type, Infra::Types::String
    attribute :earned_at, Infra::Types::DateTime.default { Time.current.to_datetime }

    alias_method :aggregate_id, :user_id
  end
end
