require_relative "../../../shared_kernel/lib/shared_kernel/types/reward_definition"

module Rewarding
  class CreateRewardPool < Infra::Command
    attribute :pool_id, Infra::Types::UUID
    attribute :rewardable_id, Infra::Types::UUID
    attribute :rewardable_type, Infra::Types::String
    attribute :reward_definition, SharedKernel::Types::RewardDefinition

    alias :aggregate_id :pool_id

    def validate!
      raise ArgumentError, "rewardable_type must be either Quest or SpecialBadgeReadModel" unless 
        ['Questing::QuestReadModel', 'Gamification::SpecialBadgeReadModel'].include?(rewardable_type)
    end
  end

  class IssueReward < Infra::Command
    attribute :pool_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID

    alias_method :aggregate_id, :pool_id
  end

  class UpdateRewardPool < Infra::Command
    attribute :pool_id, Infra::Types::UUID
    attribute :reward_definition, SharedKernel::Types::RewardDefinition

    alias_method :aggregate_id, :pool_id
  end
end
