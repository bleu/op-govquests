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

  class UpdateVotingPower < Infra::Command
    attribute :profile_id, Infra::Types::UUID
    attribute :total_voting_power, Infra::Types::Float
    attribute :voting_power_relative_to_votable_supply, Infra::Types::Float

    alias_method :aggregate_id, :profile_id
  end

  class AchieveTier < Infra::Command
    attribute :profile_id, Infra::Types::UUID
    attribute :tier_id, Infra::Types::UUID

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

    alias_method :aggregate_id, :leaderboard_id
  end

  class CreateBadge < Infra::Command
    attribute :badge_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash
    attribute :badgeable_id, Infra::Types::UUID
    attribute :badgeable_type, Infra::Types::String

    alias_method :aggregate_id, :badge_id
  end
  
  class UpdateBadge < Infra::Command
    attribute :badge_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash

    alias_method :aggregate_id, :badge_id
  end

  class EarnBadge < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :badge_id, Infra::Types::UUID
    attribute :badge_type, Infra::Types::String
    attribute :earned_at, Infra::Types::DateTime.default { Time.current.to_datetime }

    alias_method :aggregate_id, :user_id
  end
  
  class CreateSpecialBadge < Infra::Command
    attribute :badge_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash
    attribute :badge_type, Infra::Types::String
    attribute :badge_data, Infra::Types::Hash

    alias_method :aggregate_id, :badge_id
  end

  class UpdateSpecialBadge < Infra::Command
    attribute :badge_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash
    attribute :badge_data, Infra::Types::Hash

    alias_method :aggregate_id, :badge_id
  end

  class AssociateRewardPool < Infra::Command
    attribute :badge_id, Infra::Types::UUID
    attribute :pool_id, Infra::Types::UUID
    attribute :reward_definition, Infra::Types::Hash

    alias :aggregate_id :badge_id
  end

  class UnlockSpecialBadge < Infra::Command
    attribute :badge_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID

    alias :aggregate_id :badge_id
  end

  class CollectSpecialBadge < Infra::Command
    attribute :badge_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID

    alias :aggregate_id :badge_id
  end

  class CreateTier < Infra::Command 
    attribute :tier_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash
    attribute :min_delegation, Infra::Types::Integer
    attribute :max_delegation, Infra::Types::Integer.optional
    attribute :multiplier, Infra::Types::Float
    attribute :image_url, Infra::Types::String

    alias :aggregate_id :tier_id
  end

  class UpdateTier < Infra::Command
    attribute :tier_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash
    attribute :min_delegation, Infra::Types::Integer
    attribute :max_delegation, Infra::Types::Integer.optional
    attribute :multiplier, Infra::Types::Float
    attribute :image_url, Infra::Types::String

    alias :aggregate_id :tier_id
  end

  class CreateGameProfile < Infra::Command
    attribute :profile_id, Infra::Types::UUID

    alias :aggregate_id :profile_id
  end

  class UpdateGameProfileRank < Infra::Command
    attribute :profile_id, Infra::Types::UUID
    attribute :rank, Infra::Types::Integer

    alias :aggregate_id :profile_id
  end
end
