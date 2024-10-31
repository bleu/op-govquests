module Rewarding
  class CreateRewardPool < Infra::Command
    attribute :pool_id, Infra::Types::UUID
    attribute :quest_id, Infra::Types::UUID
    attribute :reward_definition, Infra::Types::Hash # {type:, amount:}
    attribute :initial_inventory, Infra::Types::Integer.optional

    alias_method :aggregate_id, :pool_id
  end

  class IssueReward < Infra::Command
    attribute :pool_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID

    alias_method :aggregate_id, :pool_id
  end

  class ClaimReward < Infra::Command
    attribute :pool_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID

    alias_method :aggregate_id, :pool_id
  end
end
