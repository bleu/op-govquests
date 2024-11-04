require_relative "types/reward_definition"
require_relative "types/claim_metadata"
module Rewarding
  class CreateRewardPool < Infra::Command
    attribute :pool_id, Infra::Types::UUID
    attribute :quest_id, Infra::Types::UUID
    attribute :reward_definition, Rewarding::Types::RewardDefinition
    attribute :initial_inventory, Infra::Types::Integer.optional

    alias_method :aggregate_id, :pool_id
  end

  class IssueReward < Infra::Command
    attribute :pool_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID

    alias_method :aggregate_id, :pool_id
  end

  class StartClaim < Infra::Command
    attribute :pool_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :claim_metadata, Rewarding::Types::ClaimMetadata

    alias_method :aggregate_id, :pool_id
  end

  class CompleteClaim < Infra::Command
    attribute :pool_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :claim_metadata, Rewarding::Types::ClaimMetadata

    alias_method :aggregate_id, :pool_id
  end
end
