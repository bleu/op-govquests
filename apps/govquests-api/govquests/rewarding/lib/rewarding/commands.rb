module Rewarding
  class CreateReward < Infra::Command
    attribute :reward_id, Infra::Types::UUID
    attribute :reward_type, Infra::Types::String
    attribute :value, Infra::Types::Integer
    attribute :expiry_date, Infra::Types::DateTime.optional

    alias_method :aggregate_id, :reward_id
  end

  class IssueReward < Infra::Command
    attribute :reward_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID

    alias_method :aggregate_id, :reward_id
  end

  class ClaimReward < Infra::Command
    attribute :reward_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID

    alias_method :aggregate_id, :reward_id
  end
end
