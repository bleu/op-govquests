module Gamification
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

  class EarnBadge < Infra::Command
    attribute :profile_id, Infra::Types::UUID
    attribute :badge, Infra::Types::String

    alias_method :aggregate_id, :profile_id
  end

  class UpdateLeaderboard < Infra::Command
    attribute :leaderboard_id, Infra::Types::UUID
    attribute :profile_id, Infra::Types::UUID
    attribute :score, Infra::Types::Integer

    alias_method :aggregate_id, :leaderboard_id
  end
end
