module Rewarding
  class RewardPoolCreated < Infra::Event
    attribute :pool_id, Infra::Types::UUID
    attribute :rewardable_id, Infra::Types::UUID
    attribute :rewardable_type, Infra::Types::String
    attribute :reward_definition, SharedKernel::Types::RewardDefinition
  end

  class RewardIssued < Infra::Event
    attribute :pool_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :reward_definition, SharedKernel::Types::RewardDefinition
    attribute :issued_at, Infra::Types::Time
  end

  class RewardPoolUpdated < Infra::Event
    attribute :pool_id, Infra::Types::UUID
    attribute :reward_definition, SharedKernel::Types::RewardDefinition
  end
end
