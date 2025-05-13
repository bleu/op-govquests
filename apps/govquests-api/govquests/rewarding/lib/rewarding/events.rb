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

  class TokenTransferConfirmed < Infra::Event
    attribute :pool_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :amount, Infra::Types::Integer
    attribute :transaction_hash, Infra::Types::String
    attribute :confirmed_at, Infra::Types::Time
  end
end
